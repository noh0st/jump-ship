extends CanvasLayer

var main_menu_scene : PackedScene = load("res://Scenes/MainMenu.tscn")


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	self.visible = false
	pass # Replace with function body.



func _on_ContinueButton_pressed():
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
