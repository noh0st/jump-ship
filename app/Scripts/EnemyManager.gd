extends Node

var _enemies = []
const Enemy: PackedScene = preload("res://Scenes/Enemy.tscn")
const RockTurtle: PackedScene = preload("res://Scenes/RockTurtle.tscn")

enum Type {
	ENEMY,
	ROCK_TURTLE,
}

# manages pools for each enemy type

# Function to spawn a new enemy
func spawn(type: int) -> Node:
	match type:
		Type.ENEMY:
			return spawn_enemy()
		Type.ROCK_TURTLE:
			return spawn_rock_turtle()
		_:
			print("ERROR: type not valid %d" % type)
			return spawn_enemy()


func spawn_enemy() -> Node:
	var new_enemy: Node = Enemy.instance()
	_enemies.append(new_enemy)
	add_child(new_enemy)
	
	return new_enemy


func spawn_rock_turtle() -> Node:
	var new_enemy: Node = RockTurtle.instance()
	_enemies.append(new_enemy)
	add_child(new_enemy)
	
	return new_enemy


func size() -> int:
	return _enemies.size()


# Function to remove an enemy
func remove_enemy(enemy: Node) -> void:
	if _enemies.has(enemy):
		enemy.queue_free()
		_enemies.erase(enemy)
