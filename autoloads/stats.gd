extends Node

@export var default_stats: StatsResource

var stats: StatsResource

func _enter_tree() -> void:
	stats = default_stats.duplicate()
