class_name Enemy extends Area2D

@onready var sprite: Sprite = $SpritePlus

var health = 1

# Bullets
var bullet_scene = preload("res://bullets/bullet.tscn")

func get_hurt():
	health -= 1
	if health <= 0:
		die()

func die():
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	if area is Bullet:
		var bullet = area as Bullet
		if bullet.is_player_bullet:
			get_hurt()
