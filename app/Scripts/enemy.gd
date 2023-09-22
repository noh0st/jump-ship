extends RigidBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	position = Vector2(300, 50)



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_RigidBody2D_body_entered() -> void:
	print("Enemy detects collision")

func _on_RigidBody2D_body_shape_entered():
	print("Enemy detects shape collision")
