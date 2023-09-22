extends KinematicBody2D

signal health_update(new_value)
var velocity = Vector2.ZERO
const MaxSpeed = 500.0
const Acceleration_Friction = 20.0
const DashPower = 5
var Stamina = 100.0 setget StaminaSet
signal ChangedStamina
var MaxStamina = 100.0
var Dir: Vector2
onready var timer = $Timer
onready var sectimer = $Timer2
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
func _onready():
	Stamina = MaxStamina
export var speed : float = 10.0
var health : int = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_meta("Player", true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var inputvector : Vector2 = Vector2.ZERO
	if Dir == Vector2.ZERO:
		Dir = Vector2(1, 0)
	inputvector.x = Input.get_action_strength("MovementRight") - Input.get_action_strength("MovementLeft")
	inputvector.y = Input.get_action_strength("MovementDown") - Input.get_action_strength("MovementUp")
	var collision : KinematicCollision2D = move_and_collide(velocity * delta, false)
	if  collision:
		if collision.collider.is_in_group("Enemies"):
			_handle_enemy_collision()

	if inputvector != Vector2.ZERO:
		
		velocity += inputvector.normalized() * Acceleration_Friction * delta
		velocity = velocity.clamped(MaxSpeed*delta)
		Dir = inputvector
		animationTree.set("parameters/Idle/blend_position", Dir)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, Acceleration_Friction* delta)

	print(Stamina)
	move_and_collide(velocity)
	
	Dash()
	
func Dash():
	if  Input.is_action_just_pressed("Dash") == true :
		StaminaChanged()
		move_and_slide(Dir * (DashPower * MaxSpeed))
		Stamina -= 10;
		timer.start()
		
func StaminaRefill():
	Stamina = move_toward(Stamina, MaxStamina, 5.0)
	if Stamina != MaxStamina:
		timer.start()
func StaminaChanged():
	print("staminaChanged")
	timer.stop()
	sectimer.start()
	
	


func _on_Timer_timeout():
	print("Timerranout")
	StaminaRefill()


func _on_Timer2_timeout():
	print("Timer2ranout")
	timer.start() # Replace with function body.

func StaminaSet(value):
	emit_signal("ChangedStamina")
	


func _handle_enemy_collision() -> void:
	health -= 10
	emit_signal("health_update", health)

