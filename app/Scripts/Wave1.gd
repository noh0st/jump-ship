extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export var xp_threshold: int = 100
onready var _hud = get_node("/root/Main/HUD")

# Called when the node enters the scene tree for the first time.
func _ready():
	_hud.reset()
	pass # Replace with function body.

