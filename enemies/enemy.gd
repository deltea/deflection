class_name Enemy extends Area2D

@export_range(0.0, 1.0) var cash_drop_chance = 0.5

@onready var sprite: Sprite = $SpritePlus

var health = 1

var explosion_scene = preload("res://particles/explosion.tscn")
var cash_scene = preload("res://cash.tscn")
var bullet_scene = preload("res://bullets/bullet.tscn")

func _ready() -> void:
	await Clock.wait(0.5)
	start()

func start():
	pass

func get_hurt():
	health -= 1
	if health <= 0:
		die()

func die():
	Events.enemy_die.emit(self)
	set_deferred("monitoring", false)

	# Clock.slowmo()
	sprite.impact(1.5)
	Clock.hitstop(0.05)
	Globals.camera.shake(0.1, 1.0)

	var explosion = explosion_scene.instantiate() as CPUParticles2D
	explosion.position = position
	explosion.emitting = true
	explosion.finished.connect(explosion.queue_free)
	Globals.arena.add_child(explosion)

	if randf() <= cash_drop_chance: drop_cash()

	queue_free()

func drop_cash():
	var cash = cash_scene.instantiate() as Cash
	cash.position = position
	cash.starting_direction = Vector2.from_angle(randf_range(0, PI*2))
	Globals.arena.call_deferred("add_child", cash)

func get_hit_by_bullet(bullet: Bullet):
	Globals.camera.jerk_direction(bullet.position - position, 5)#20.0)
	bullet.hit_enemy()
	get_hurt()

func _on_area_entered(area: Area2D) -> void:
	if area is Bullet:
		var bullet = area as Bullet
		if bullet.is_player_bullet:
			get_hit_by_bullet(bullet)
