extends Node

export(Array, Resource) var presentUpgrades

func AddAndApplyUpgrade(added_upgrade):
	presentUpgrades.append(added_upgrade)
	if added_upgrade.has_method("Upgrade"):
		added_upgrade.Upgrade()
		PlayerStats.UpgradedValues()
		
func _ready():
	AddAndApplyUpgrade(load("res://Recources/new_resource.tres"))
