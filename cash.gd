class_name Cash extends Area2D

@export var starting_rotation_velocity = 500.0
@export var rotation_damping = 200.0
@export var starting_velocity = 100.0
@export var velocity_damping = 50.0
@export var disappear_delay = 5.0
@export var flash_duration = 2.0

@onready var sprite: Sprite = $SpritePlus
@onready var disappear_timer: Timer = $DisappearTimer

var velocity = Vector2.ZERO
var rotation_velocity = 0
var starting_direction = Vector2.ZERO
var picked_up = false

func _ready() -> void:
	velocity = starting_velocity * starting_direction
	rotation_velocity = starting_rotation_velocity * (1 if randf() > 0.5 else -1)

	disappear_timer.wait_time = disappear_delay
	disappear_timer.start()

func _process(delta: float) -> void:
	rotation_velocity = move_toward(rotation_velocity, 0.0, rotation_damping * delta)
	sprite.target_rotation_degrees += rotation_velocity * delta

	position += velocity * delta
	velocity = velocity.move_toward(Vector2.ZERO, velocity_damping * delta)

func pick_up():
	picked_up = true
	sprite.impact_expand(2, 0.2)
	sprite.stop_flash()

	await Clock.wait(0.3)

	queue_free()
	Events.get_cash.emit()

func _on_body_entered(body: Node2D) -> void:
	if body is Wall:
		velocity = velocity.bounce(Vector2.from_angle(body.rotation - PI/2))

func _on_disappear_timer_timeout() -> void:
	sprite.flash(0.1, flash_duration)
	await sprite.flash_finished
	if picked_up: return
	queue_free()
