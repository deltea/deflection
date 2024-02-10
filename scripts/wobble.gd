class_name Wobble extends Node2D

@export var speed = 2.0
@export var magnitude = 20.0

func _process(delta: float) -> void:
	rotation_degrees = sin(speed * Clock.time * delta) * magnitude
