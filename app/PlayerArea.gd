extends Area2D

signal health_update

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var speed = 400 # allows use in inspector
var screen_size

var health = 100
var velocity
# Called when the node enters the scene tree for the first time.
func _ready():
	print("hello")
	screen_size = get_viewport_rect().size
	position = Vector2(50, 50)



func _on_Player_body_entered(body: Node) -> void:
	health -= 10
	emit_signal("health_update", health)
	# emit health update signal
	


func _on_Area2D_body_entered(body):
	pass # Replace with function body.
