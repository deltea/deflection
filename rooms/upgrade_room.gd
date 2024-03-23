class_name UpgradeRoom extends Room

@onready var money_label: Label = $Money/MoneyLabel
@onready var upgrade_row: Row = $UpgradeRow

var upgrade_scene = preload("res://ui/upgrade_button.tscn")

func _ready() -> void:
	money_label.text = str(UpgradeManager.current_money)
	spawn_upgrades(UpgradeManager.shop_slots)
	UpgradeManager.upgrades_rerolled.connect(_on_upgrades_rerolled)

func _on_upgrades_rerolled():
	for child in upgrade_row.get_children():
		if child is UpgradeButton:
			child.queue_free()

	spawn_upgrades(UpgradeManager.shop_slots)

func spawn_upgrades(amount: int):
	for i in range(amount):
		var random_upgrade = UpgradeManager.all_upgrades.pick_random()
		var upgrade_button = upgrade_scene.instantiate() as UpgradeButton
		upgrade_button.set_values(random_upgrade)
		upgrade_row.add_child(upgrade_button)
		upgrade_row.move_child(upgrade_button, 0)

func _on_continue_clicked() -> void:
	get_tree().change_scene_to_packed(load("res://rooms/arena_room.tscn"))
