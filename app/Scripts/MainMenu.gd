extends Control



func _on_Button_pressed():
	$PressedSFX.play()
	
	


func _on_Button_mouse_entered():
	$HoveredSFX.play()


func _on_PressedSFX_finished():
	get_tree().change_scene("res://Scenes/Main.tscn")
	print("Play")
