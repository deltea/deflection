class_name Arena extends Node2D

@onready var background: Sprite2D = $SwirlyBackground
@onready var arena_background: Sprite2D = $Floor/ArenaBackground

func _enter_tree() -> void:
	Globals.arena = self

func _ready() -> void:
	background.material.set_shader_parameter("color_1", ColorPalette.colors.dark)
	background.material.set_shader_parameter("color_2", ColorPalette.colors.accent)

	arena_background.self_modulate = ColorPalette.colors.dark
