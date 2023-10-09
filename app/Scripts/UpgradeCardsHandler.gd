extends TextureButton

var AssignedUpgrade : Upgrades setget CardAssign



func _on_Upgrade_pressed():
	get_tree().paused = false
	print("pressed", AssignedUpgrade.UpgradeName)
	get_parent().HideUpgrade()
	print($Description.text, $Name.text)

func CardAssign(value):
	AssignedUpgrade = value
	$Description.text = AssignedUpgrade.UpgradeDescription
	$Name.text = AssignedUpgrade.UpgradeName
	$Sprite.texture = load(AssignedUpgrade.UpgradeSpritePath)
	
