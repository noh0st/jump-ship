extends Control

const gameplay_scene = preload("res://Scenes/Main.tscn")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_PlayButton_pressed():
	get_parent().add_child(gameplay_scene.instance())
	queue_free() # safely destroy this node
	pass # Replace with function body.
