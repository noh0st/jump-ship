extends Control



func _on_QuitGameButton_pressed():
	get_tree().quit()
	

func _on_StartGameButton_pressed():
	$PressedSFX.play()
	


func _on_PressedSFX_finished():
	get_tree().change_scene("res://Scenes/Main.tscn")


func _on_StartGameButton_mouse_entered():
	$HoveredSFX.play()


func _on_QuitGameButton_mouse_entered():
	$HoveredSFX.play()
