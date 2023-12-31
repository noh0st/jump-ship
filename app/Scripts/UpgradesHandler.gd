extends Node

export(Array, Resource) var AllUpgrades
var AvailableUpgrades = []
onready var upgradeStation = $Control/UpgradeStation
onready var upgrade_1 = $Control/Upgrade_1
onready var upgrade_2 = $Control/Upgrade_2
onready var upgrade_3 = $Control/Upgrade_3

var on_select_callback: FuncRef

func AddAndApplyUpgrade(added_upgrade):
	if added_upgrade != null:
		added_upgrade.Upgrade()
		AvailableUpgrades.clear()
		AvailableUpgrades.append_array(AllUpgrades)
		$UpgradeSFX.play()
		print("added_upgrade")
		print(AvailableUpgrades, AllUpgrades)
		
		
func _ready():
	HideUpgrade()
	AvailableUpgrades.append_array(AllUpgrades)
	print(AvailableUpgrades, AllUpgrades)
	# self.get_child(i).connect("ChoseUpgrade", self, "AddAndApplyUpgrade", [self.get_child(i).AssignedUpgrade])
	
			
func UpgradesPOPUP(callback: FuncRef):
	#print(AvailableUpgrades)
	get_tree().paused = true
	ShowUpgrade()
	AssignRandomUpgrades()
	on_select_callback = callback
	
	
func AssignRandomUpgrades():
	if AvailableUpgrades.size() == AllUpgrades.size():
		upgrade_1.CardAssign(AvailableUpgrades[randi() % AvailableUpgrades.size()], funcref(self, "_on_selection")) 
		AvailableUpgrades.remove(AvailableUpgrades.find(upgrade_1.AssignedUpgrade))
		
		upgrade_2.CardAssign(AvailableUpgrades[randi() % AvailableUpgrades.size()], funcref(self, "_on_selection")) 
		AvailableUpgrades.remove(AvailableUpgrades.find(upgrade_2.AssignedUpgrade))

		upgrade_3.CardAssign(AvailableUpgrades[randi() % AvailableUpgrades.size()], funcref(self, "_on_selection"))
		AvailableUpgrades.remove(AvailableUpgrades.find(upgrade_3.AssignedUpgrade))
		print("AssignedUpgrades", upgrade_1.AssignedUpgrade,upgrade_2.AssignedUpgrade,upgrade_3.AssignedUpgrade)
	elif AvailableUpgrades.size() != AllUpgrades.size():
		AvailableUpgrades.clear()
		AvailableUpgrades.append_array(AllUpgrades)
		AssignRandomUpgrades()
func _on_selection(card: Node) -> void:
	get_tree().paused = false
	print("pressed", card.AssignedUpgrade.UpgradeName)
	HideUpgrade()
	on_select_callback.call_func()


func HideUpgrade():
	self.visible = false
	#upgradeStation.visible = false
	#upgrade_1.visible = false
	#upgrade_2.visible = false
	#upgrade_3.visible = false
	
	
func ShowUpgrade():
	self.visible = true
	
	#upgradeStation.visible = true
	#upgrade_1.visible = true
	#upgrade_2.visible = true
	#upgrade_3.visible = true


func _on_Upgrade_1_pressed():
	AddAndApplyUpgrade(upgrade_1.AssignedUpgrade)
	#print(upgrade_1.AssignedUpgrade)



func _on_Upgrade_2_pressed():
	AddAndApplyUpgrade(upgrade_2.AssignedUpgrade)


func _on_Upgrade_3_pressed():
	AddAndApplyUpgrade(upgrade_3.AssignedUpgrade)
