extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	# initialize health UI with player
	$HUD.init($YSort/Player)
	
	$WaveManager.init($YSort/Player, $Upgrades, $YSort/EnemyManager, $HUD)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
