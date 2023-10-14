extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var xp_threshold: int = 300

onready var NextWave: PackedScene = load("res://Scenes/WaveBoss.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():	
	pass # Replace with function body.

