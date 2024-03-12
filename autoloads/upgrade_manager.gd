class_name Upgrades extends Node

var current_money = 0

func _ready() -> void:
	Events.get_cash.connect(_on_get_cash)

func reset():
	current_money = 0

func _on_get_cash():
	current_money += 1
