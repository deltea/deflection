class_name RotatingTurretEnemy extends Enemy

@export var bullet_speed = 100.0
@export var speed = 2.0
@export var bullet_offset = 16.0

var fire_timer = 0.0
var rotate_timer = speed / 4

func _process(delta: float) -> void:
	if fire_timer >= speed / 2:
		fire_timer = 0.0
		fire()
	if rotate_timer >= speed / 2:
		rotate_timer = 0.0
		turn()

	fire_timer += delta
	rotate_timer += delta

func fire() -> void:
	sprite.impact_expand(1.2)
	for i in range(4):
		var bullet = bullet_scene.instantiate() as Bullet
		bullet.rotation = sprite.rotation + PI/2 * i
		bullet.position = position + Vector2.from_angle(bullet.rotation) * bullet_offset
		bullet.speed = bullet_speed
		Globals.arena.add_child(bullet)

func turn() -> void:
	sprite.target_rotation_degrees += 45.0
