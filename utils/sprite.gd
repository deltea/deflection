class_name Sprite extends Sprite2D

@export_group("Dynamics")
@export var scale_dynamics_enabled = true
@export var scale_dynamics: DynamicsResource
@export var rotation_dynamics_enabled = true
@export var rotation_dynamics: DynamicsResource

@export_group("Shadow")
@export var use_shadow = false
@export var shadow_texture: Texture2D
@export var shadow_offset = Vector2(0, 0)
@export var shadow_scale = Vector2.ONE
@export var shadow_ordering = -20

@onready var flash_timer: Timer = $FlashTimer

signal flash_finished

var target_scale = Vector2.ONE
var target_rotation_degrees = 0.0

var scale_dynamics_solver: DynamicsSolverVector
var rotation_dynamics_solver: DynamicsSolver

var shadow: Sprite2D

func _ready() -> void:
	scale_dynamics_solver = Dynamics.create_dynamics_vector(scale_dynamics)
	rotation_dynamics_solver = Dynamics.create_dynamics(rotation_dynamics)

	target_scale = global_scale
	target_rotation_degrees = global_rotation_degrees

	if use_shadow:
		shadow = Sprite2D.new()
		shadow.top_level = true
		shadow.texture = shadow_texture
		shadow.self_modulate = Color.RED
		shadow.offset = shadow_offset
		shadow.global_scale = shadow_scale
		shadow.z_index = shadow_ordering
		shadow.flip_h = flip_h
		shadow.flip_v = flip_v
		shadow.scale = shadow_scale
		add_child(shadow)

func _process(_delta: float) -> void:
	if scale_dynamics and scale_dynamics_enabled:
		global_scale = scale_dynamics_solver.update(target_scale)
	else:
		global_scale = target_scale

	if rotation_dynamics and rotation_dynamics_enabled:
		global_rotation_degrees = rotation_dynamics_solver.update(target_rotation_degrees)
	else:
		global_rotation_degrees = target_rotation_degrees

	if use_shadow:
		shadow.global_position = global_position
		shadow.global_scale = global_scale * shadow_scale

func impact_expand(size: float, duration: float = 0.1):
	target_scale = Vector2.ONE * size
	await Clock.wait(duration)
	target_scale = Vector2.ONE

func flash(interval: float = 0.1, duration = 0):
	flash_timer.wait_time = interval
	flash_timer.start()
	if duration > 0:
		await Clock.wait(duration)
		stop_flash()

func stop_flash():
	flash_finished.emit()
	flash_timer.stop()
	visible = true

func _on_flash_timer_timeout() -> void:
	visible = not visible
