extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var xp_threshold: int = 180

onready var NextWave: PackedScene = load("res://Scenes/Wave3.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():	
	pass # Replace with function body.

