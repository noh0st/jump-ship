extends CanvasLayer

var main_menu_scene : PackedScene = load("res://Scenes/MainMenu.tscn")



func _ready():
	visible = false
	PlayerStats.connect("Death", self ,"_on_PlayerStats_Death")
	
func _on_QuitButton_pressed():
	print("EXIT")
	PlayerStats.ResetValues()
	var main_menu_instance : Node = main_menu_scene.instance()
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
	
	



func _on_RestartButton_pressed():
	PlayerStats.ResetValues()
	get_tree().reload_current_scene()
	get_tree().change_scene("res://Scenes/Main.tscn")
	
 

func _on_PlayerStats_Death():
	print("died")
	visible = true# Replace with function body.
