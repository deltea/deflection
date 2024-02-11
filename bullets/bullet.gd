class_name Bullet extends Area2D

var is_player_bullet = false
var speed = 0.0
var health = 1

func _physics_process(delta: float) -> void:
	position += Vector2.from_angle(rotation) * speed * delta

func switch_to_player():
	is_player_bullet = true
	rotation = Globals.player.get_angle_to(get_global_mouse_position())
	speed = Stats.stats.bullet_speed

func destroy():
	queue_free()

func bounce(normal: Vector2):
	rotation = Vector2.from_angle(rotation).bounce(normal).angle()

func _on_body_entered(body: Node2D) -> void:
	if body is Wall:
		health -= 1
		if health <= 0: destroy()
		else: bounce(Vector2.ONE)
