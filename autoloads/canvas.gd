extends Node

@export var mouse_rotate_speed = 10.0
@export var player_health_dynamics: DynamicsResource

@onready var mouse: TextureRect = $Canvas/Mouse
@onready var player_health: TextureProgressBar = $CameraCanvas/PlayerHealth
@onready var dash_bar: TextureProgressBar = $CameraCanvas/DashBar
@onready var canvas: CanvasLayer = $Canvas
@onready var camera_canvas: CanvasLayer = $CameraCanvas

var mouse_target_rotation = 0.0
var player_health_dynamics_solver: DynamicsSolverVector

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN

	ColorPalette.set_color_palette_replace(mouse.material)

	player_health.tint_under = ColorPalette.colors.dark
	player_health.tint_over = ColorPalette.colors.light
	player_health.tint_progress = ColorPalette.colors.accent

	dash_bar.tint_under = ColorPalette.colors.dark
	dash_bar.tint_over = ColorPalette.colors.dark
	dash_bar.tint_progress = ColorPalette.colors.accent

	var half_viewport = get_viewport().get_visible_rect().size / 2
	camera_canvas.offset = Globals.camera.base_offset - half_viewport

	player_health_dynamics_solver = Dynamics.create_dynamics_vector(player_health_dynamics)

	Events.health_change.connect(_on_health_change)

func _process(delta: float) -> void:
	var target = get_viewport().get_mouse_position()
	mouse.position = target - mouse.size / 2
	mouse.rotation_degrees = lerp(mouse.rotation_degrees, mouse_target_rotation, mouse_rotate_speed * delta)

	if Input.is_action_just_pressed("lmb"):
		mouse_target_rotation += 180 * (1 if mouse_target_rotation < 0 else -1)

	player_health.value = Globals.player.health
	player_health.scale = player_health_dynamics_solver.update(Vector2.ONE)

func _on_health_change(_new_health: float):
	player_health_dynamics_solver.set_current(Vector2.ONE * 1.2)
