class_name Room extends Node2D

@export var mouse_mode: Canvas.MOUSE_MODE = Canvas.MOUSE_MODE.CROSSHAIR

func _enter_tree() -> void:
	Globals.current_room = self
