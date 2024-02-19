class_name WalkingEnemy extends Enemy

@export var speed = 80.0
@export var bullet_speed = 50.0
@export var bullet_offset = -16.0

@onready var fire_timer: Timer = $FireTimer

var target_rotation = 0

func _ready() -> void:
	super._ready()
	set_physics_process(false)
	await Clock.wait(randf_range(0, fire_timer.wait_time))
	fire_timer.start()

func start():
	set_physics_process(true)
	target_rotation = rotation#randf_range(0, PI*2)

func _physics_process(delta: float) -> void:
	sprite.target_rotation_degrees = rad_to_deg(target_rotation)
	position += Vector2.from_angle(target_rotation) * speed * delta

func _on_body_entered(body: Node2D) -> void:
	if body is Wall:
		var normal = Vector2.from_angle(body.rotation - PI/2)
		target_rotation = Vector2.from_angle(target_rotation).bounce(normal).angle()

func _on_fire_timer_timeout() -> void:
	sprite.impact_expand(1.2)
	var bullet = bullet_scene.instantiate() as Bullet
	bullet.rotation = target_rotation + PI
	bullet.position = position + Vector2.from_angle(target_rotation) * bullet_offset
	bullet.speed = bullet_speed
	Globals.arena.add_child(bullet)
