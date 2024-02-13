class_name Arena extends Node2D

@onready var background: Sprite2D = $SwirlyBackground

func _enter_tree() -> void:
	Globals.arena = self

func _ready() -> void:
	background.material.set_shader_parameter("color_2", ColorPalette.colors.accent)
