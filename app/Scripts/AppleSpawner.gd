extends Node2D

onready var _timer = $Timer
var apple = preload("res://Scenes/Apple.tscn")
onready var MainYsort = self.get_parent().get_parent().get_parent()

func _on_Timer_timeout():
	var new_apple = apple.instance()
	MainYsort.add_child(new_apple)
	new_apple.position = Vector2(rand_range(get_parent().position.x -60,get_parent().position.x + 60),rand_range(get_parent().position.x -60, get_parent().position.y + 60))
	print("spawned apple at" ,new_apple.position)
