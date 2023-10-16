extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	# initialize health UI with player
	$HUD.init($YSort/Player)
	
	$YSort/EnemyManager.init($YSort)
	
	$WaveManager.init($YSort/Player, $Upgrades, $YSort/EnemyManager, $HUD)
	


func _on_WaveManager_on_game_win():
	# open win menu
	get_tree().paused = true	
	$WinMenu.visible = true
	
	# play the credits music
	print("GAME WIN")
	
	# destroy player
	pass
