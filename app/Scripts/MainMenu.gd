extends Control



func _on_Button_mouse_entered():
	$HoveredSFX.play()



func _on_QuitGameButton_pressed():
	get_tree().quit()


func _on_StartGameButton_pressed():
	$PressedSFX.play()
	get_tree().change_scene("res://Scenes/Main.tscn")


func _on_PressedSFX_finished():
	pass # Replace with function body.


func _on_StartGameButton_mouse_entered():
	pass # Replace with function body.
