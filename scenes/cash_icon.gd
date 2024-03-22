class_name CashIcon extends Sprite2D

@export var spin_speed = 100.0

func _process(delta: float) -> void:
	rotation_degrees += spin_speed * delta
