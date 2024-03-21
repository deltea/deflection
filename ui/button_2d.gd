class_name Button2D extends Area2D

@export var sprite: Sprite

func _on_mouse_entered() -> void:
	if sprite: sprite.target_scale = Vector2.ONE * 1.1

func _on_mouse_exited() -> void:
	if sprite: sprite.target_scale = Vector2.ONE * 1.0
