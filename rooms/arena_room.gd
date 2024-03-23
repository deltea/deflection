class_name ArenaRoom extends Room

func _ready() -> void:
	Stats.reset_stats()
	UpgradeManager.activate_upgrades()
