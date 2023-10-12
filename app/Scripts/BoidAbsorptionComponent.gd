extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var _player: Node 


func _on_enemy_death(enemy: Node) -> void:
	_player.add_boid()
	

# Called when the node enters the scene tree for the first time.

func init(enemy_manager):
	_player = get_parent()
	enemy_manager.subscribe_to_deaths(funcref(self, "_on_enemy_death"))

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
