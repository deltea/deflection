class_name Upgrades extends Node

var current_money = 1234567890
var all_upgrades: Array[UpgradeObject]

signal upgrades_created

func _enter_tree() -> void:
	Events.get_cash.connect(_on_get_cash)
	create_upgrades()

func reset():
	current_money = 0

func create_upgrade(upgrade_object: UpgradeObject):
	all_upgrades.push_back(upgrade_object)

func create_upgrades():
	create_upgrade(UpgradeObject.new("The Wheel", load("res://assets/upgrades/upgrade.png")))
	create_upgrade(UpgradeObject.new("The Circle", load("res://assets/upgrades/upgrade-2.png")))
	create_upgrade(UpgradeObject.new("The Basketball", load("res://assets/upgrades/upgrade-3.png")))
	upgrades_created.emit()

func _on_get_cash():
	current_money += 1
