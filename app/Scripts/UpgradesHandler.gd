extends Node

export(Array, Resource) var AllUpgrades
var AvailableUpgrades = []
onready var upgradeStation = $UpgradeStation
onready var upgrade_1 = $Upgrade_1
onready var upgrade_2 = $Upgrade_2
onready var upgrade_3 = $Upgrade_3

func AddAndApplyUpgrade(added_upgrade):
	if added_upgrade != null:
		added_upgrade.Upgrade()
		AvailableUpgrades.clear()
		AvailableUpgrades.append_array(AllUpgrades)
		print("added_upgrade")
		print(AvailableUpgrades, AllUpgrades)
func _ready():
	HideUpgrade()
	AvailableUpgrades.append_array(AllUpgrades)
	print(AvailableUpgrades, AllUpgrades)
	PlayerStats.connect("newLevel", self, "UpgradesPOPUP")
	#self.get_child(i).connect("ChoseUpgrade", self, "AddAndApplyUpgrade", [self.get_child(i).AssignedUpgrade])
	
	
			
func UpgradesPOPUP():
	#print(AvailableUpgrades)
	get_tree().paused = true
	ShowUpgrade()
	AssignRandomUpgrades()
	

	
	
func AssignRandomUpgrades():
	
	
	upgrade_1.AssignedUpgrade = AvailableUpgrades[randi() % AvailableUpgrades.size()]
	AvailableUpgrades.remove(AvailableUpgrades.find(upgrade_1.AssignedUpgrade))
	upgrade_2.AssignedUpgrade = AvailableUpgrades[randi() % AvailableUpgrades.size()]
	AvailableUpgrades.remove(AvailableUpgrades.find(upgrade_2.AssignedUpgrade))
	upgrade_3.AssignedUpgrade = AvailableUpgrades[randi() % AvailableUpgrades.size()]

func HideUpgrade():
	upgradeStation.visible = false
	upgrade_1.visible = false
	upgrade_2.visible = false
	upgrade_3.visible = false
func ShowUpgrade():
	upgradeStation.visible = true
	upgrade_1.visible = true
	upgrade_2.visible = true
	upgrade_3.visible = true


func _on_Upgrade_1_pressed():
	AddAndApplyUpgrade(upgrade_1.AssignedUpgrade)
	#print(upgrade_1.AssignedUpgrade)



func _on_Upgrade_2_pressed():
	AddAndApplyUpgrade(upgrade_2.AssignedUpgrade)


func _on_Upgrade_3_pressed():
	AddAndApplyUpgrade(upgrade_3.AssignedUpgrade)
