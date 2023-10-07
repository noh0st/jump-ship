extends CanvasLayer

var main_menu_scene : PackedScene = load("res://Scenes/MainMenu.tscn")



func _ready():
	visible = false
	PlayerStats.connect("Death", self ,"_on_PlayerStats_Death")
	
func _on_QuitButton_pressed():
	print("EXIT")
	PlayerStats.ResetValues()
	GlobalUpgradeStats.GlobalReset()
	
	get_tree().change_scene_to(main_menu_scene)
	
	get_tree().paused = false

func _on_RestartButton_pressed():
	PlayerStats.ResetValues()
	GlobalUpgradeStats.GlobalReset()
	get_tree().paused = false	
	get_tree().reload_current_scene()
	get_tree().change_scene("res://Scenes/Main.tscn")
	
 
func _on_PlayerStats_Death():
	death()

func death():
	print("died")
	get_tree().paused = true
	visible = true# Replace with function body.
	
func _on_Player_player_boid_count_update(new_value):
	if new_value == 0:
		death()
