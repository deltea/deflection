class_name Cash extends Area2D

@export var rotate_speed = 100.0
@export var starting_velocity = 100.0
@export var velocity_damping = 50.0

@onready var sprite: Sprite = $SpritePlus

var velocity = Vector2.ZERO
var starting_direction = Vector2.ZERO

func _ready() -> void:
	sprite.material.set_shader_parameter("new_color", ColorPalette.colors.accent)
	velocity = starting_velocity * starting_direction

func _process(delta: float) -> void:
	sprite.target_rotation_degrees += rotate_speed * delta

	position += velocity * delta
	velocity = velocity.move_toward(Vector2.ZERO, velocity_damping * delta)

func pick_up():
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is Wall:
		velocity = velocity.bounce(Vector2.from_angle(body.rotation - PI/2))
