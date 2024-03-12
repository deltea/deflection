class_name WaveManager extends Node

@export var test_formation: PackedScene
@export var formation_scenes: Array[PackedScene]

var wave = 0
var enemies = 0
var current_formation: Node2D

func _ready() -> void:
	Events.enemy_die.connect(_on_enemy_die)

	next_wave()

func next_wave():
	wave += 1

	var formation_scene = test_formation if test_formation else formation_scenes.pick_random()
	var formation = formation_scene.instantiate() as WaveFormation
	formation.global_position = Vector2.ZERO
	Globals.current_room.call_deferred("add_child", formation)
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
