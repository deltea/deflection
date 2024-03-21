class_name Button2D extends Area2D

@export var press_scale = 0.95
@export var hover_scale = 1.1
@export var sprite: Sprite

var hovering = false
var pressing = false

func _on_mouse_entered() -> void:
	hovering = true
	if sprite: sprite.target_scale = hover_scale * Vector2.ONE

func _on_mouse_exited() -> void:
	hovering = false
	if sprite: sprite.target_scale = 1.0 * Vector2.ONE

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		pressing = event.pressed
		if sprite:
			var target_scale = press_scale if pressing else hover_scale
			sprite.target_scale = target_scale * Vector2.ONE
