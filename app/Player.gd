extends Area2D

signal health_update

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var speed = 400 # allows use in inspector
var screen_size

var health = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	print("hello")
	screen_size = get_viewport_rect().size
	position = Vector2(50, 50)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	# check for input
	var velocity = Vector2.ZERO # The player's movement vector.
	
	if(Input.is_physical_key_pressed(KEY_D)):
		velocity.x += 1
	elif(Input.is_physical_key_pressed(KEY_A)):
		velocity.x -= 1
	
	# move
	position += velocity * speed * delta
	
	# animation

func _on_Player_body_entered(body: Node) -> void:
	health -= 10
	emit_signal("health_update", health)
	# emit health update signal
	
