class_name Row extends Node2D

@export var padding = 10

func _process(delta: float) -> void:
	for i in get_child_count():
		var child = get_child(i)
		if not child is Node2D: continue

		child.position.x = i * 120
