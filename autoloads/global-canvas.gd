class_name Canvas extends CanvasLayer

enum MOUSE_MODE {
	CROSSHAIR,
	POINTER,
}

@export var mouse_rotate_speed = 10.0
@export var crosshair_texture: Texture2D
@export var pointer_texture: Texture2D

@onready var mouse: TextureRect = $Mouse

var mouse_target_rotation = 0.0

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN

	match Globals.current_room.mouse_mode:
		MOUSE_MODE.CROSSHAIR:
			mouse.texture = crosshair_texture
		MOUSE_MODE.POINTER:
			mouse.texture = pointer_texture

func _process(delta: float) -> void:
	var target = get_viewport().get_mouse_position()
	mouse.position = target - mouse.size / 2
	mouse.rotation_degrees = lerp(mouse.rotation_degrees, mouse_target_rotation, mouse_rotate_speed * delta)

	if Input.is_action_just_pressed("lmb"):
		match Globals.current_room.mouse_mode:
			MOUSE_MODE.CROSSHAIR:
				mouse_target_rotation += 180 * (1 if mouse_target_rotation < 0 else -1)
			MOUSE_MODE.POINTER:
				mouse_target_rotation += 0 * (1 if mouse_target_rotation < 0 else -1)
