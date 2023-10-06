extends Node

export(Array, Resource) var presentUpgrades

func AddAndApplyUpgrade(added_upgrade):
	if added_upgrade != null:
		presentUpgrades.append(added_upgrade)
		if added_upgrade.has_method("Upgrade"):
			added_upgrade.Upgrade()
			PlayerStats.UpgradedValues()
		
func _ready():

	$Control/ConfirmationDialog.popup()
	


func _on_ConfirmationDialog_confirmed():
	AddAndApplyUpgrade($Control/ConfirmationDialog.AssignedUpgrade)
