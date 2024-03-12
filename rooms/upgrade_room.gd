class_name UpgradeRoom extends Room

@export var cash_icon_spin_speed = 100.0

@onready var money_label: Label = $Canvas/Money/MoneyLabel
@onready var cash_icon: TextureRect = $Canvas/Money/CashIcon

func _ready() -> void:
	money_label.text = str(UpgradeManager.current_money)

func _process(delta: float) -> void:
	cash_icon.rotation_degrees += cash_icon_spin_speed * delta
