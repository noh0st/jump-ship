extends Node

export(Array, Resource) var AllUpgrades
var AvailableUpgrades = []
onready var upgradeStation = $UpgradeStation
onready var upgrade_1 = $Upgrade_1
onready var upgrade_2 = $Upgrade_2
onready var upgrade_3 = $Upgrade_3

func AddAndApplyUpgrade(added_upgrade):
	if added_upgrade != null:
		if added_upgrade.has_method("Upgrade"):
			added_upgrade.Upgrade()
			AvailableUpgrades = AllUpgrades
			print(added_upgrade)
func _ready():
	upgradeStation.visible = false
	upgrade_1.visible = false
	upgrade_2.visible = false
	upgrade_3.visible = false
	AvailableUpgrades = AllUpgrades
	PlayerStats.connect("newLevel", self, "UpgradesPOPUP")
	#self.get_child(i).connect("ChoseUpgrade", self, "AddAndApplyUpgrade", [self.get_child(i).AssignedUpgrade])
	for i in range(self.get_child_count() - 1):
		if self.get_child(i).has_method("_on_Upgrade_pressed"):
			self.get_child(i).connect("ChoseUpgrade", self, "AddAndApplyUpgrade", [self.get_child(i).AssignedUpgrade])
			
func UpgradesPOPUP():
	get_tree().paused = true
	AssignRandomUpgrades()
	upgradeStation.visible = true
	upgrade_1.visible = true
	upgrade_2.visible = true
	upgrade_3.visible = true
	
func RandomPOPUP() -> int:
	var i_random = randi() % len(AvailableUpgrades)
	AvailableUpgrades.remove(i_random)
	return i_random
	
func AssignRandomUpgrades():
	upgrade_1.AssignedUpgrade = AllUpgrades[0]
	#upgrade_2.AssignedUpgrade = AllUpgrades[0]
	#upgrade_3.AssignedUpgrade = AllUpgrades[0]
