class_name Enemy extends Area2D

@onready var sprite: Sprite = $SpritePlus

var health = 1

var explosion_scene = preload("res://particles/explosion.tscn")
# Bullets
var bullet_scene = preload("res://bullets/bullet.tscn")

func _ready() -> void:
	await Clock.wait(1.0)
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

	await Clock.hitstop(0.04)
	await sprite.impact_expand(1.5, 0.05)
	Globals.camera.shake(0.05, 2)

	var explosion = explosion_scene.instantiate() as CPUParticles2D
	explosion.position = position
	explosion.emitting = true
	explosion.finished.connect(explosion.queue_free)
	Globals.arena.add_child(explosion)

	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area is Bullet:
		var bullet = area as Bullet
		if bullet.is_player_bullet:
			bullet.hit_enemy()
			get_hurt()
