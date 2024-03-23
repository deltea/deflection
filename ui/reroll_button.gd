class_name RerollButton extends Button2D

func _on_clicked() -> void:
	UpgradeManager.reroll_upgrades()
