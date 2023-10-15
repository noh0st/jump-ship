extends Control



func _on_Button_pressed():
	$PressedSFX.play()
	
	
func _on_Button_mouse_entered():
	$HoveredSFX.play()



func _on_QuitGameButton_pressed():
	get_tree().quit()


func _on_StartGameButton_pressed():
	get_tree().change_scene("res://Scenes/Main.tscn")
