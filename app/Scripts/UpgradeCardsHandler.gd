extends TextureButton

var AssignedUpgrade : Upgrades

var _on_selection: FuncRef

func _on_Upgrade_pressed():
	_on_selection.call_func(self)

	print($Description.text, $Name.text)


func CardAssign(value, on_selection):
	_on_selection = on_selection
	
	AssignedUpgrade = value
	$Description.text = AssignedUpgrade.UpgradeDescription
	$Name.text = AssignedUpgrade.UpgradeName
	$Sprite.texture = load(AssignedUpgrade.UpgradeSpritePath)
	
