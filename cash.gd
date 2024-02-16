class_name Cash extends Area2D

@export var starting_rotation_velocity = 100.0
@export var rotation_damping = 50.0
@export var starting_velocity = 100.0
@export var velocity_damping = 50.0

@onready var sprite: Sprite = $SpritePlus

var velocity = Vector2.ZERO
var rotation_velocity = 0
var starting_direction = Vector2.ZERO

func _ready() -> void:
	sprite.material.set_shader_parameter("new_color", ColorPalette.colors.accent)
	velocity = starting_velocity * starting_direction
	rotation_velocity = starting_rotation_velocity * randf_range(0, PI*2)

func _process(delta: float) -> void:
	rotation_velocity = move_toward(rotation_velocity, 0.0, rotation_damping * delta)
	sprite.target_rotation_degrees += rotation_velocity * delta

	position += velocity * delta
	velocity = velocity.move_toward(Vector2.ZERO, velocity_damping * delta)

func pick_up():
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is Wall:
		velocity = velocity.bounce(Vector2.from_angle(body.rotation - PI/2))
