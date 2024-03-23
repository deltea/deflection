class_name Upgrades extends Node

var current_money = 1234567890
var all_upgrades: Array[UpgradeObject]
var starting_reroll_price = 5
var reroll_price = 0
var shop_slots = 3

signal upgrades_rerolled

func _enter_tree() -> void:
	Events.get_cash.connect(_on_get_cash)
	create_upgrades()

func _ready() -> void:
	reroll_price = starting_reroll_price

func reset():
	current_money = 0

func reroll_upgrades():
	reroll_price += 1
	upgrades_rerolled.emit()

func create_upgrade(upgrade_object: UpgradeObject):
	all_upgrades.push_back(upgrade_object)

func create_upgrades():
	create_upgrade(UpgradeObject.new("The Wheel", load("res://assets/upgrades/upgrade.png")))
	create_upgrade(UpgradeObject.new("The Circle", load("res://assets/upgrades/upgrade-2.png")))
	create_upgrade(UpgradeObject.new("The Basketball", load("res://assets/upgrades/upgrade-3.png")))

func _on_get_cash():
	current_money += 1
