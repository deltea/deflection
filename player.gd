class_name Player extends CharacterBody2D

@export_category("Animation")
@export var walk_tilt = 5.0
@export var walk_tilt_speed = 1500.0
@export var bat_rotation_offset = 90.0
@export var bat_rotation_dynamics: DynamicsResource

@onready var sprite: Sprite = $SpritePlus
@onready var bat: Node2D = $Bat
@onready var bat_sprite: Sprite2D = $Bat/BatSprite
@onready var parry_area: Area2D = $ParryArea

var bat_rotation = 0.0
var bat_rotation_dynamics_solver: DynamicsSolver

func _enter_tree() -> void:
	Globals.player = self

func _ready() -> void:
	bat_rotation = bat_rotation_offset
	bat_rotation_dynamics_solver = Dynamics.create_dynamics(bat_rotation_dynamics)

func _process(_delta: float) -> void:
	var mouse_angle = get_angle_to(get_global_mouse_position()) + PI/2
	bat.rotation = mouse_angle + bat_rotation_dynamics_solver.update(deg_to_rad(bat_rotation))
	parry_area.rotation = mouse_angle

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * Stats.stats.movement_speed * delta

	if direction:
		sprite.target_rotation_degrees = sin(Clock.time * walk_tilt_speed * delta) * walk_tilt
	else:
		sprite.target_rotation_degrees = 0

	if Input.is_action_just_pressed("lmb"):
		swing_bat()

	move_and_slide()

func swing_bat():
	bat_rotation = -bat_rotation

	var bullets = parry_area.get_overlapping_areas().filter(func(area): return area is Bullet)
	for bullet in bullets:
		var distance = bullet.position.distance_to(bat_sprite.global_position)
		await Clock.wait(distance / 1000)
		bullet.switch_to_player()
		Clock.hitstop(0.04)
