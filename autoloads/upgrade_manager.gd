class_name Upgrades extends Node

var current_money = 1234567890
var all_upgrades: Array[UpgradeObject]
var upgrade_scene = preload("res://ui/upgrade_button.tscn")

func _ready() -> void:
	Events.get_cash.connect(_on_get_cash)
	create_upgrades()
	spawn_upgrades(3)

func reset():
	current_money = 0

func spawn_upgrades(amount: int):
	for i in range(amount):
		var random_upgrade = all_upgrades.pick_random()
		var upgrade = upgrade_scene.instantiate()
		upgrade.set_values(random_upgrade)
		upgrade.position = Vector2(i * 120 + 100, 142)
		add_child(upgrade)

func create_upgrade(upgrade_object: UpgradeObject):
	all_upgrades.push_back(upgrade_object)

func create_upgrades():
	create_upgrade(UpgradeObject.new("The Wheel", load("res://assets/upgrades/upgrade.png")))
	create_upgrade(UpgradeObject.new("The Circle", load("res://assets/upgrades/upgrade-2.png")))
	create_upgrade(UpgradeObject.new("The Basketball", load("res://assets/upgrades/upgrade-3.png")))

func _on_get_cash():
	current_money += 1
