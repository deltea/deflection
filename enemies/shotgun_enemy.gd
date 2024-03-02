class_name ShotgunEnemy extends Enemy

@export var rotation_speed = 80.0
@export var bullet_num = 3
@export var bullet_spread = 50.0
@export var bullet_offset = 16.0
@export var bullet_speed = 100.0

@onready var fire_timer: Timer = $FireTimer

var rotation_direction = 0.0

func start():
	rotation_direction = 1 if randf() > 0.5 else -1
	await Clock.wait(randf_range(0, fire_timer.wait_time))
	fire_timer.start()

func _process(delta: float) -> void:
	sprite.target_rotation_degrees += rotation_speed * rotation_direction * delta

func _on_fire_timer_timeout() -> void:
	sprite.impact(1.5)

	# Super complicated angles
	var angle = 0.0
	if bullet_num % 2 == 0: angle = -(bullet_num - 1) * bullet_spread / 2
	else: angle = -floorf(bullet_num / 2.0) * bullet_spread

	for i in range(bullet_num):
		var bullet = bullet_scene.instantiate() as Bullet
		bullet.rotation_degrees = sprite.global_rotation_degrees + angle
		bullet.position = global_position + Vector2.from_angle(bullet.rotation) * bullet_offset
		bullet.speed = bullet_speed
		Globals.current_room.add_child(bullet)
		angle += bullet_spread
