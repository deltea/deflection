extends Node

@export var formation_scenes: Array[PackedScene]

var wave = 0
var enemy_num = 3

func _ready() -> void:
	Events.enemy_die.connect(_on_enemy_die)

	next_wave()

func next_wave():
	wave += 1

	var random_formation_scene = formation_scenes.pick_random()
	var formation = random_formation_scene.instantiate() as WaveFormation
	formation.global_position = Vector2.ZERO
	Globals.arena.add_child(formation)
	enemy_num = formation.get_child_count()

func _on_enemy_die(_enemy: Enemy):
	enemy_num -= 1
	if enemy_num <= 0: next_wave()
