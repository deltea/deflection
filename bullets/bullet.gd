class_name Bullet extends CharacterBody2D

@export var texture_1: Texture2D
@export var texture_2: Texture2D
@export var player_bullet_texture: Texture2D

@onready var sprite: Sprite = $SpritePlus
@onready var blink_timer: Timer = $BlinkTimer
@onready var trail: Trail = $Trail
@onready var area: Area2D = $Area

var is_player_bullet = false
var speed = 0.0
var health = 1
var combo = 0

func _ready() -> void:
	reset_health()
	trail.emitting = false

func _physics_process(delta: float) -> void:
	velocity = Vector2.from_angle(rotation) * speed
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.get_collider() is Wall:
			var wall = collision.get_collider() as Wall
			health -= 1
			if health > 0 and is_player_bullet:
				var normal = Vector2.from_angle(wall.rotation + PI/2)
				rotation = Vector2.from_angle(rotation).bounce(normal).angle()
			else: destroy()

func switch_to_player(autoaim):
	var target_direction = get_global_mouse_position() - global_position
	if is_instance_valid(autoaim) and autoaim is AutoaimArea:
		target_direction = autoaim.global_position - global_position

	is_player_bullet = true
	trail.emitting = true
	rotation = target_direction.angle()
	speed = Stats.bullet_speed
	sprite.impact(1.5)
	sprite.texture = player_bullet_texture
	reset_health()

	# Just in case an enemy is touching a bullet
	var enemies_touching = area.get_overlapping_areas().filter(func(a): return a is Enemy)
	for enemy in enemies_touching:
		enemy.get_hit_by_bullet(self)

func destroy():
	queue_free()

func hit_enemy():
	combo += 1

func reset_health():
	health = Stats.bullet_bounce + 1

func _on_blink_timer_timeout() -> void:
	if not texture_1 or not texture_2 or is_player_bullet: return

	if sprite.texture == texture_1:
		sprite.texture = texture_2
	else:
		sprite.texture = texture_1

func _on_visible_on_screen_notifier_screen_exited() -> void:
	destroy()
