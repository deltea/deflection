@tool
class_name Row extends Node2D

@export var padding = 100

func _process(_delta: float) -> void:
	var child_count = get_child_count()
	print(child_count)

	var x = 0
	if child_count % 2 == 0: x = -(child_count - 1) * padding / 2.0
	else: x = -floorf(child_count / 2.0) * padding

	for i in child_count:
		var child = get_child(i)
		if not child is Node2D: continue

		child.position.x = x
		x += padding
