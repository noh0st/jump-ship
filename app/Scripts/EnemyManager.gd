extends Node

var _enemies = []
const Enemy: PackedScene = preload("res://Scenes/Enemy.tscn")

# Function to spawn a new enemy
func spawn_enemy() -> Node:
	var new_enemy: Node = Enemy.instance()
	_enemies.append(new_enemy)
	add_child(new_enemy)
	
	return new_enemy


func size() -> int:
	return _enemies.size()


# Function to remove an enemy
func remove_enemy(enemy) -> void:
	if _enemies.has(enemy):
		enemy.queue_free()
		_enemies.erase(enemy)
