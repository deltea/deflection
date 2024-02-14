class_name Bullet extends Area2D

@export var texture_1: Texture2D
@export var texture_2: Texture2D
@export var player_bullet_texture: Texture2D

@onready var sprite: Sprite = $SpritePlus
@onready var blink_timer: Timer = $BlinkTimer

var is_player_bullet = false
var speed = 0.0
var health = 1
var combo = 0

func _ready() -> void:
	sprite.material.set_shader_parameter("new_color", ColorPalette.colors.accent)
	reset_health()

func _physics_process(delta: float) -> void:
	position += Vector2.from_angle(rotation) * speed * delta

func switch_to_player():
	is_player_bullet = true
	rotation = (get_global_mouse_position() - global_position).angle()
	speed = Stats.stats.bullet_speed
	sprite.impact_expand(1.5)
	sprite.texture = player_bullet_texture
	reset_health()

func destroy():
	queue_free()

func bounce(normal: Vector2):
	rotation = Vector2.from_angle(rotation).bounce(normal).angle()

func hit_enemy():
	combo += 1

func reset_health():
	health = Stats.stats.bullet_bounce + 1

func _on_body_entered(body: Node2D) -> void:
	if body is Wall:
		health -= 1
		if health > 0: bounce(Vector2.from_angle(body.rotation - PI/2))

func _on_blink_timer_timeout() -> void:
	if not texture_1 or not texture_2 or is_player_bullet: return

	if sprite.texture == texture_1:
		sprite.texture = texture_2
	else:
		sprite.texture = texture_1

func _on_visible_on_screen_notifier_screen_exited() -> void:
	destroy()
