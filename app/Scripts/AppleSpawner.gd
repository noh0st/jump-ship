extends Node2D

onready var _timer = $Timer
var apple = preload("res://Scenes/Apple.tscn")
onready var MainYsort = get_node("../YSort")

func _on_Timer_timeout():
	var new_apple = apple.instance()
	MainYsort.add_child(new_apple)
	new_apple.position = Vector2(rand_range(-1000, 1000),rand_range(-1000, 350))
	print("spawned applae at" ,new_apple.position)
