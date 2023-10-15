extends Node2D

onready var _hud = get_node("/root/Main/HUD")
onready var _player = get_node("/root/Main/YSort/Player")
onready var wave_manager = get_node("/root/Main/WaveManager")

export var xp_threshold: int = 100
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	$Enemies/BossEnemy.init(_hud.get_node("BossHealthBar"), _player)
	_hud.enable_boss_health_bar()
	
	$Enemies/BossEnemy.connect("on_dead", self, "_on_boss_dead")
	
	pass # Replace with function body.
	
func _on_boss_dead():
	wave_manager.game_win()
