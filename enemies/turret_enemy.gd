class_name TurretEnemy extends Enemy

@export var bullet_speed = 100.0
@export var bullet_num = 3
@export var bullet_delay = 0.3
@export var bullet_offset = 16.0

@onready var fire_timer: Timer = $FireTimer

func start() -> void:
	await Clock.wait(randf_range(0, fire_timer.wait_time))
	fire_timer.start()

func _process(_delta: float) -> void:
	sprite.target_rotation_degrees = rad_to_deg(get_angle_to(Globals.player.position))

func _on_fire_timer_timeout() -> void:
	for i in range(bullet_num):
		sprite.impact(1.5)
		var bullet = bullet_scene.instantiate() as Bullet
		bullet.rotation = sprite.rotation
		bullet.position = global_position + Vector2.from_angle(bullet.rotation) * bullet_offset
		bullet.speed = bullet_speed
		Globals.current_room.add_child(bullet)
		await Clock.wait(bullet_delay)
