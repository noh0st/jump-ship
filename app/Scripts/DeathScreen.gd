extends CanvasLayer

var main_menu_scene : PackedScene = load("res://Scenes/MainMenu.tscn")



func _ready():
	visible = false
	PlayerStats.connect("Death", self ,"_on_PlayerStats_Death")
	
func _on_QuitButton_pressed():
	print("EXIT")
	PlayerStats.ResetValues()

	get_tree().change_scene("res://Scenes/MainMenu.tscn")
	
	

func _on_RestartButton_pressed():
	PlayerStats.ResetValues()
	get_tree().paused = false	
	get_tree().reload_current_scene()
	get_tree().change_scene("res://Scenes/Main.tscn")
	
 
func _on_PlayerStats_Death():
	print("died")
	get_tree().paused = true
	visible = true# Replace with function body.
