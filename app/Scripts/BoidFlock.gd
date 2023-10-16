extends Node

signal boid_count_update(new_value)

onready var ysort = get_node("/root/Main/YSort")


var _boids: Array = []
const Boid: PackedScene = preload("res://Scenes/Boid.tscn")

var flock_owner: Node2D

func _ready() -> void:
	flock_owner = get_parent()


func spawn_boid() -> Node:

	
	var boid: Node = Boid.instance()
	_boids.append(boid)
	
	if not is_instance_valid(flock_owner):
		print("ERROR FLOCK OWNER NOT VALID")
		return boid
	
	boid.position = flock_owner.position + _random_direction() * 200
		
	boid.flock = self
	
	ysort.call_deferred("add_child", boid)
	
	emit_signal("boid_count_update", _boids.size())
	
	return boid


func boids() -> Array:
	return _boids


func size() -> int:
	return _boids.size()


func owner_position() -> Vector2:
	return flock_owner.position

func release_boid() -> void:
	if _boids.size() == 0:
		return
		
	remove(_boids[0])
	
func _random_direction() -> Vector2:
	var angle = rand_range(0, 2 * PI)
	return Vector2(cos(angle), sin(angle)).normalized()
	
	
func remove(object: Node) -> void:
	if _boids.has(object):
		object.queue_free()
		_boids.erase(object)
		
		emit_signal("boid_count_update", _boids.size())
		
func HealBoids(value):
	for i in _boids:
		i.add_health(value)
		
