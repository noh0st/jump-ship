extends Node

var _enemies = []
const Enemy: PackedScene = preload("res://Scenes/Enemy.tscn")
const RockTurtle: PackedScene = preload("res://Scenes/RockTurtle.tscn")
const SpearEnemy: PackedScene = preload("res://Scenes/SpearLanceEnemy.tscn")
const RatEnemy : PackedScene = preload("res://Scenes/RatEnemy.tscn")
onready var MainYsort = get_node("../YSort")

const X_BOUNDS = Vector2(-1000, 1000)
const Y_BOUNDS = Vector2(-1000, 350)


var XPPlayer : int = 50 #xp added to player on death
enum Type {
	ENEMY,
	ROCK_TURTLE,
	SPEAR,
	RAT
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
		Type.RAT:
			return _spawn_rat()
		_:
			print("ERROR: type not valid %d" % type)
			return _spawn_enemy()


func _spawn_enemy() -> Node:
	var new_enemy: Node = Enemy.instance()
	_enemies.append(new_enemy)
	MainYsort.add_child(new_enemy)
	
	return new_enemy


func add_enemy(enemy: Node) -> void:
	_enemies.append(enemy)
	print(_enemies)


func _spawn_rock_turtle() -> Node:
	var new_enemy: Node = RockTurtle.instance()
	_enemies.append(new_enemy)
	MainYsort.add_child(new_enemy)
	
	return new_enemy

func _spawn_spear() -> Node:
	var new_enemy: Node = SpearEnemy.instance()
	_enemies.append(new_enemy)
	
	MainYsort.add_child(new_enemy)
	return new_enemy

func _spawn_rat() -> Node:
	var new_enemy: Node = RatEnemy.instance()
	_enemies.append(new_enemy)
	
	MainYsort.add_child(new_enemy)
	return new_enemy
	
	
func size() -> int:
	return _enemies.size()


# Function to remove an enemy
func remove_enemy(enemy: Node) -> void:
	if _enemies.has(enemy):
		$EnemyDeathSFX.play()
		fire_death_event(enemy)
		_enemies.erase(enemy)
	enemy.queue_free()


func subscribe_to_deaths(callback: FuncRef) -> void:
	_on_death_callbacks.append(callback)


func fire_death_event(enemy: Node) -> void:
	for callback in _on_death_callbacks:
		callback.call_func(enemy)
