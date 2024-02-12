extends Node

@export var enemy_scenes: Array[PackedScene]

var wave = 0
var enemy_num = 3
var enemies: Array[Enemy] = []

func _ready() -> void:
	Events.enemy_die.connect(_on_enemy_die)

	next_wave()

func next_wave():
	enemy_num += 1
	for i in range(enemy_num):
		var random_enemy_scene = enemy_scenes.pick_random()
		var enemy = random_enemy_scene.instantiate()
		var random_pos = Vector2(randf_range(-212, 212), randf_range(-110, 110))
		enemy.global_position = random_pos
		enemies.push_back(enemy)
		Globals.arena.add_child(enemy)

func _on_enemy_die(enemy: Enemy):
	var index = enemies.find(enemy)
	if index != -1:
		enemies.remove_at(index)
		if len(enemies) <= 0:
			next_wave()
