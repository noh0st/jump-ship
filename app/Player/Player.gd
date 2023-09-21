extends KinematicBody2D
var velocity = Vector2.ZERO
const MaxSpeed = 500.0
const Acceleration_Friction = 20.0
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var inputvector : Vector2 = Vector2.ZERO
	inputvector.x = Input.get_action_strength("MovementRight") - Input.get_action_strength("MovementLeft")
	inputvector.y = Input.get_action_strength("MovementDown") - Input.get_action_strength("MovementUp")
	
	print(inputvector)
	if inputvector != Vector2.ZERO:
		velocity += inputvector.normalized() * Acceleration_Friction * delta
		velocity = velocity.clamped(MaxSpeed*delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, Acceleration_Friction* delta)
	print(velocity)
	move_and_collide(velocity)
