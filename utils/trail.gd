class_name Trail extends Line2D

@export var point_removal_delay = 0.5

@onready var curve: Curve2D = Curve2D.new()

var target_position: Vector2
var point_removal_timer = 0.0

func _process(delta: float) -> void:
	if not target_position: return

	if point_removal_timer >= point_removal_delay:
		if curve.get_baked_points().size() > 0: curve.remove_point(0)
		point_removal_timer = point_removal_delay
	else:
		point_removal_timer += delta

	curve.add_point(target_position)
	points = curve.get_baked_points()

func reset():
	curve.clear_points()
	# clear_points()
