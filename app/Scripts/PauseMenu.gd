extends CanvasLayer

var main_menu_scene : PackedScene = load("res://Scenes/MainMenu.tscn")


# setget keyword creates a set/get, here only created a set
var is_paused = false setget set_is_paused

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		self.is_paused = !is_paused

func set_is_paused(value: bool) -> void:
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused

# Called when the node enters the scene tree for the first time.
func _ready():
	self.is_paused = false


func _on_ResumeButton_pressed():
	print("RESUME")
	self.is_paused = false
	

func _on_QuitButton_pressed():
	print("EXIT")
	PlayerStats.ResetValues()
	
	
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
	
	
	self.is_paused = false
