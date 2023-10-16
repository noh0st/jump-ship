extends Node2D

onready var _timer = $Timer
var apple = preload("res://Scenes/Apple.tscn")
onready var MainYsort = get_node("/root/Main/YSort")


var apples = []
const MAX_APPLES = 4


func _on_Timer_timeout():
	if apples.size() >= MAX_APPLES:
		$Timer.stop()
		return
	
	var new_apple = apple.instance()
	new_apple.init(funcref(self, "_on_apple_freed"))
	MainYsort.call_deferred("add_child", new_apple)
	var sz = 50
	new_apple.position = Vector2(rand_range(global_position.x - sz, global_position.x + sz),rand_range(global_position.y - sz, global_position.y + sz))
	$Timer.start(rand_range(3,6))
	apples.append(new_apple)


func _on_apple_freed(apple: Node) -> void:
	if apples.has(apple):
		apples.erase(apple)
	$Timer.start(rand_range(3,6))
