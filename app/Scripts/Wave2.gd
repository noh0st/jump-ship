extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var xp_threshold: int = 250

onready var NextWave: PackedScene = load("res://Scenes/Wave2.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
