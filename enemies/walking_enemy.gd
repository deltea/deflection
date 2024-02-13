class_name WalkingEnemy extends Enemy

@export var speed = 100.0

var target_rotation = 0

func _ready() -> void:
	super._ready()
	set_physics_process(false)

func start():
	set_physics_process(true)
	target_rotation = randf_range(0, 360)

func _physics_process(delta: float) -> void:
	sprite.target_rotation_degrees = target_rotation
	position += Vector2.from_angle(deg_to_rad(target_rotation)) * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body is Wall:
		var normal = Vector2.from_angle(body.rotation - PI/2)
		target_rotation = rad_to_deg(Vector2.from_angle(deg_to_rad(target_rotation)).bounce(normal).angle())
