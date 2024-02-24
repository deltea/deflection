extends CanvasLayer

@export var mouse_rotate_speed = 10.0

@onready var mouse: TextureRect = $Mouse

var mouse_target_rotation = 0.0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN

	ColorPalette.set_color_palette_replace(mouse.material)

func _process(delta: float) -> void:
	var target = get_viewport().get_mouse_position()
	mouse.position = target - mouse.size / 2
	mouse.rotation_degrees = lerp(mouse.rotation_degrees, mouse_target_rotation, mouse_rotate_speed * delta)

	if Input.is_action_just_pressed("lmb"):
		mouse_target_rotation += 180 * (1 if mouse_target_rotation < 0 else -1)
