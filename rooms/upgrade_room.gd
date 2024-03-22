class_name UpgradeRoom extends Room

@export var cash_icon_spin_speed = 100.0

@onready var money_label: Label = $Money/MoneyLabel
@onready var cash_icon: Sprite2D = $Money/CashIcon
@onready var upgrade_row: Row = $UpgradeRow

var upgrade_scene = preload("res://ui/upgrade_button.tscn")

func _ready() -> void:
	money_label.text = str(UpgradeManager.current_money)
	spawn_upgrades(3)

func _process(delta: float) -> void:
	cash_icon.rotation_degrees += cash_icon_spin_speed * delta

func spawn_upgrades(amount: int):
	for i in range(amount):
		var random_upgrade = UpgradeManager.all_upgrades.pick_random()
		var upgrade_button = upgrade_scene.instantiate() as UpgradeButton
		upgrade_button.set_values(random_upgrade)
		upgrade_row.add_child(upgrade_button)
