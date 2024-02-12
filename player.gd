class_name Player extends CharacterBody2D

@export var walk_tilt = 5.0
@export var walk_tilt_speed = 1500.0
@export var bat_rotation_offset = 125.0
@export var bat_rotation_dynamics: DynamicsResource
@export var impulse_damping = 500.0
@export var dash_impulse_damping = 5000.0
@export var dash_force = 1000.0

@onready var sprite: Sprite = $SpritePlus
@onready var bat: Node2D = $Bat
@onready var bat_sprite: Sprite = $Bat/BatSprite
@onready var parry_area: Area2D = $ParryArea
@onready var hitbox: Area2D = $Hitbox

var bat_rotation = 0.0
var bat_rotation_dynamics_solver: DynamicsSolver
var impulse_velocity = Vector2.ZERO
var dash_impulse_velocity = Vector2.ZERO
var mouse_angle: float

func _enter_tree() -> void:
	Globals.player = self

func _ready() -> void:
	bat_rotation = bat_rotation_offset
	bat_rotation_dynamics_solver = Dynamics.create_dynamics(bat_rotation_dynamics)

func _process(_delta: float) -> void:
	mouse_angle = get_angle_to(get_global_mouse_position()) + PI/2
	bat.rotation = mouse_angle + bat_rotation_dynamics_solver.update(deg_to_rad(bat_rotation))
	parry_area.rotation = mouse_angle
	bat_sprite.target_rotation_degrees = bat.rotation_degrees

func _physics_process(delta: float) -> void:
	var input = Input.get_vector("left", "right", "up", "down")
	velocity = input * Stats.stats.movement_speed * delta + impulse_velocity + dash_impulse_velocity
	impulse_velocity = impulse_velocity.move_toward(Vector2.ZERO, impulse_damping * delta)
	dash_impulse_velocity = dash_impulse_velocity.move_toward(Vector2.ZERO, dash_impulse_damping * delta)
	sprite.target_rotation_degrees = sin(Clock.time * walk_tilt_speed * delta) * walk_tilt if input else 0.0

	if Input.is_action_just_pressed("lmb"):
		swing_bat()

	if Input.is_action_just_pressed("rmb"):
		dash()

	move_and_slide()

func knockback(direction: Vector2, force: float):
	impulse_velocity = direction.normalized() * force

func swing_bat():
	bat_rotation = -bat_rotation
	knockback(position - get_global_mouse_position(), 100)

	var bullets = parry_area.get_overlapping_areas().filter(func(area): return area is Bullet)
	for bullet in bullets:
		if not bullet: continue
		var distance = bullet.position.distance_to(bat_sprite.global_position)
		await Clock.wait(distance / 1000)
		bullet.switch_to_player()
		Clock.hitstop(0.05)
		knockback(position - get_global_mouse_position(), 200)
		bat_sprite.impact_expand(1.5)

func dash():
	dash_impulse_velocity = (get_global_mouse_position() - position).normalized() * dash_force
