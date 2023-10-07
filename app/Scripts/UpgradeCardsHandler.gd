extends TextureButton
signal ChoseUpgrade
export var AssignedUpgrade : Resource



func _on_Upgrade_pressed():
	emit_signal("ChoseUpgrade")
	get_tree().paused = false
	print("pressed")
	
