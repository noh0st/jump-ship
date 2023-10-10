extends Node

var _enemies = []
const Enemy: PackedScene = preload("res://Scenes/Enemy.tscn")
const RockTurtle: PackedScene = preload("res://Scenes/RockTurtle.tscn")
const SpearEnemy: PackedScene = preload("res://Scenes/SpearLanceEnemy.tscn")
var XPPlayer : int = 50 #xp added to player on death
enum Type {
	ENEMY,
	ROCK_TURTLE,
	SPEAR
}

var _on_death_callbacks: Array = []

# manages pools for each enemy type

# Function to spawn a new enemy
func spawn(type: int) -> Node:
	match type:
		Type.ENEMY:
			return _spawn_enemy()
		Type.ROCK_TURTLE:
			return _spawn_rock_turtle()
		Type.SPEAR:
			return _spawn_spear()
		_:
			print("ERROR: type not valid %d" % type)
			return _spawn_enemy()


func _spawn_enemy() -> Node:
	var new_enemy: Node = Enemy.instance()
	_enemies.append(new_enemy)
	add_child(new_enemy)
	
	return new_enemy


func _spawn_rock_turtle() -> Node:
	var new_enemy: Node = RockTurtle.instance()
	_enemies.append(new_enemy)
	add_child(new_enemy)
	
	return new_enemy

func _spawn_spear() -> Node:
	var new_enemy: Node = SpearEnemy.instance()
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
		PlayerStats.XP += XPPlayer
		fire_death_event()


func subscribe_to_deaths(callback: FuncRef) -> void:
	_on_death_callbacks.append(callback)


func fire_death_event() -> void:
	for callback in _on_death_callbacks:
		callback.call_func()
