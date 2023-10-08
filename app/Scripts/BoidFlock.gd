extends Node

signal boid_count_update(new_value)

var _boids: Array = []
const Boid: PackedScene = preload("res://Scenes/Boid.tscn")

var flock_owner: Node2D

func _ready() -> void:
	flock_owner = get_parent()


func spawn_boid() -> Node:
	var boid: Node = Boid.instance()
	_boids.append(boid)
		
	boid.flock = self
	
	add_child(boid)
	
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

func remove(object: Node) -> void:
	if _boids.has(object):
		object.queue_free()
		_boids.erase(object)
		
		emit_signal("boid_count_update", _boids.size())
