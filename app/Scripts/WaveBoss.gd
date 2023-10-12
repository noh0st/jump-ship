extends Node2D

onready var _hud = get_node("/root/Main/HUD")

onready var NextWave: PackedScene = load("res://Scenes/Wave1.tscn")

export var xp_threshold: int = 1
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Enemies/BossEnemy.init(_hud.get_node("BossHealthBar"))
	_hud.enable_boss_health_bar()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
