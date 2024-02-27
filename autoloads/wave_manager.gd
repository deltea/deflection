extends Node

@export var formation_scenes: Array[PackedScene]

var wave = 0
var enemies = 0
var current_formation: Node2D

func _ready() -> void:
	Events.enemy_die.connect(_on_enemy_die)

	next_wave()

func next_wave():
	wave += 1

	var random_formation_scene = formation_scenes.pick_random()
	var formation = random_formation_scene.instantiate() as WaveFormation
	formation.global_position = Vector2.ZERO
	Globals.arena.add_child(formation)
	current_formation = formation
	enemies = formation.get_children().filter(func(child): return child is Enemy)

func _on_enemy_die(enemy: Enemy):
	var index = enemies.find(enemy)
	if index == -1: return
	enemies.remove_at(index)
	if len(enemies) <= 0:
		current_formation.queue_free()
		await Clock.wait(0.5)
		next_wave()
