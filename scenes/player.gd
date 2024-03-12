class_name Player extends CharacterBody2D

@export var walk_tilt = 5.0
@export var walk_tilt_speed = 1500.0
@export var bat_rotation_offset = 125.0
@export var bat_rotation_dynamics: DynamicsResource
@export var bat_position_dynamics: DynamicsResource
@export var impulse_damping = 500.0
@export var dash_impulse_damping = 7000.0
@export var dash_force = 1000.0
@export var dash_duration = 0.8
@export var swing_cooldown = 0.15

@onready var sprite: Sprite = $SpritePlus
@onready var bat: Node2D = $Bat
@onready var bat_sprite: Sprite = $Bat/BatSprite
@onready var parry_area: Area2D = $ParryArea
@onready var hitbox: Area2D = $Hitbox
@onready var auto_aim_ray: RayCast2D = $ParryArea/AutoAimRay
@onready var aim_arrow: Sprite2D = $ParryArea/Arrow
@onready var world_ray: RayCast2D = $ParryArea/Arrow/WorldRay
@onready var aim_line: Line2D = $ParryArea/Arrow/AimLine

var mouse_angle: float
var can_move = true
var is_dead = false
var bat_rotation = 0.0
var bat_rotation_dynamics_solver: DynamicsSolver
var bat_position_dynamics_solver: DynamicsSolverVector
var impulse_velocity = Vector2.ZERO
var dash_impulse_velocity = Vector2.ZERO
var dash_timer = 0
var is_dashing = false
var swing_cooldown_timer = 0
var can_swing = true
var health = 100.0:
	set(value):
		health = 100.0 if value > 100.0 else value

func _enter_tree() -> void:
	Globals.player = self

func _ready() -> void:
	bat_rotation = bat_rotation_offset
	bat_rotation_dynamics_solver = Dynamics.create_dynamics(bat_rotation_dynamics)
	bat_position_dynamics_solver = Dynamics.create_dynamics_vector(bat_position_dynamics)

	Events.enemy_die.connect(_on_enemy_die)

func _process(delta: float) -> void:
	mouse_angle = get_angle_to(get_global_mouse_position()) + PI/2
	bat.position = bat_position_dynamics_solver.update(global_position)
	bat.rotation = mouse_angle + bat_rotation_dynamics_solver.update(deg_to_rad(bat_rotation))
	parry_area.rotation = mouse_angle
	bat_sprite.target_rotation_degrees = bat.rotation_degrees

	aim_line.set_point_position(0, aim_arrow.global_position + Vector2(0, -12).rotated(parry_area.rotation))
	aim_line.set_point_position(1, world_ray.get_collision_point())

	if dash_timer >= dash_duration:
		toggle_dash(false)
		dash_timer = 0.0
	else:
		dash_timer += delta

	if swing_cooldown_timer >= swing_cooldown:
		can_swing = true
		bat_sprite.rotation_dynamics_enabled = false
	else:
		swing_cooldown_timer += delta

	health -= Stats.health_decrease * delta
	if health <= 0 and not is_dead: die()

func _physics_process(delta: float) -> void:
	var input = Input.get_vector("left", "right", "up", "down")
	impulse_velocity = impulse_velocity.move_toward(Vector2.ZERO, impulse_damping * delta)
	dash_impulse_velocity = dash_impulse_velocity.move_toward(Vector2.ZERO, dash_impulse_damping * delta)
	sprite.target_rotation_degrees = sin(Clock.time * walk_tilt_speed * delta) * walk_tilt if input else 0.0

	if can_move:
		velocity = input * Stats.movement_speed * delta + impulse_velocity + dash_impulse_velocity
	else:
		velocity = Vector2.ZERO

	if Input.is_action_just_pressed("lmb") and can_move and can_swing:
		swing_bat()

	if Input.is_action_just_pressed("rmb") and can_move:
		dash()

	move_and_slide()

func knockback(direction: Vector2, force: float):
	impulse_velocity = direction.normalized() * force

func swing_bat():
	can_swing = false
	swing_cooldown_timer = 0.0
	bat_sprite.rotation_dynamics_enabled = true

	bat_rotation = -bat_rotation
	knockback(position - get_global_mouse_position(), 100)

	var bullets = parry_area.get_overlapping_bodies().filter(func(area): return area is Bullet)
	for bullet in bullets:
		deflect_bullet(bullet)

func dash():
	toggle_dash(true)
	dash_impulse_velocity = (get_global_mouse_position() - position).normalized() * dash_force

func toggle_dash(value: bool):
	is_dashing = value
	hitbox.monitoring = not value

func get_hurt(bullet: Bullet):
	bullet.destroy()
	Clock.hitstop(0.1)
	Globals.camera.shake(0.05, 3)
	Globals.camera.impact()
	knockback(position - bullet.position, 100)
	health -= Stats.hurt_health_decrease
	Events.health_change.emit(health)

func die():
	is_dead = true
	can_move = false

func deflect_bullet(bullet: Bullet):
	if not is_instance_valid(bullet): return

	var distance = bullet.position.distance_to(bat_sprite.global_position)
	var auto_aim_enemy = auto_aim_ray.get_collider()
	await Clock.wait(distance / 1000)

	if not is_instance_valid(bullet): return

	bullet.switch_to_player(auto_aim_enemy)
	Clock.hitstop(0.07)
	knockback(position - get_global_mouse_position(), 200.0)
	Globals.camera.jerk_direction(position - get_global_mouse_position(), 5.0)
	bat_sprite.impact(1.5)

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body is Bullet:
		var bullet = body as Bullet
		if bullet.is_player_bullet: return

		get_hurt(bullet)

func _on_enemy_die(_enemy: Enemy):
	health += Stats.enemy_kill_health_increase
	Events.health_change.emit(health)

func _on_pickup_area_area_entered(area: Area2D) -> void:
	if area is Cash:
		var cash = area as Cash
		cash.pick_up()
