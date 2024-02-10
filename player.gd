class_name Player extends CharacterBody2D

@export_category("Animation")
@export var walk_tilt = 15.0
@export var walk_tilt_speed = 1000.0

@onready var sprite: Sprite = $Sprite

func _ready() -> void:
	print(Stats.stats.movement_speed)

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * Stats.stats.movement_speed * delta

	if direction:
		sprite.rotation_degrees = sin(Clock.time * walk_tilt_speed * delta) * walk_tilt
	else:
		sprite.rotation_degrees = 0

	move_and_slide()
