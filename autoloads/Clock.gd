extends Node

@export var slowmo_smoothing = 0.04

var time = 0.0
var slowmo_amount = 0.0
var base_time_scale = 1.0

func _process(delta: float) -> void:
	time += delta
	slowmo_amount = move_toward(slowmo_amount, 0.0, slowmo_smoothing)
	Engine.time_scale = clamp(base_time_scale - slowmo_amount, 0, 1.0)

func wait(duration: float):
	await get_tree().create_timer(duration, false, false, true).timeout

func hitstop(duration: float):
	base_time_scale = 0.0
	await wait(duration)
	base_time_scale = 1.0

func slowmo():
	slowmo_amount = 1.0
