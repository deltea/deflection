extends CanvasLayer

@export var colors: ColorPaletteResource

@onready var overlay: TextureRect = $ColorPaletteOverlay

func _ready() -> void:
	overlay.material.set_shader_parameter("new_color_dark", colors.dark)
	overlay.material.set_shader_parameter("new_color_light", colors.light)
	overlay.material.set_shader_parameter("new_color_accent", colors.accent)
