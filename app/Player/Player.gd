extends KinematicBody2D

signal health_update(new_value)

var velocity = Vector2.ZERO
const MaxSpeed = 500.0
const Acceleration_Friction = 20.0
const DashPower = 5

var Stamina setget StaminaSet

signal ChangedStamina


var Dir: Vector2
onready var timer = $Timer
onready var sectimer = $Timer2
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree

onready var stats = $PlayerStats

func _onready():
	Stamina = stats.MaxStamina
	
var health : int = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_meta("Player", true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):

		
	if timer.time_left != 0:
		print(timer.time_left)
	if sectimer.time_left != 0:
		print(sectimer.time_left)
	var inputvector : Vector2 = Vector2.ZERO
	if Dir == Vector2.ZERO:
		Dir = Vector2(1, 0)
	inputvector.x = Input.get_action_strength("MovementRight") - Input.get_action_strength("MovementLeft")
	inputvector.y = Input.get_action_strength("MovementDown") - Input.get_action_strength("MovementUp")

	
		
			

	if inputvector != Vector2.ZERO:
		
		velocity += inputvector.normalized() * Acceleration_Friction * delta
		velocity = velocity.clamped(MaxSpeed*delta)
		Dir = inputvector
		animationTree.set("parameters/Idle/blend_position", Dir)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, Acceleration_Friction* delta)


	move_and_collide(velocity)
	
	Dash()
	
func Dash():
	if  Input.is_action_just_pressed("Dash") == true :
		
		if stats.Stamina >= stats.staminaForDash:
			stats.Stamina -= stats.staminaForDash;
			timer.start()
			print("start Refill")
			move_and_slide(Dir * (DashPower * MaxSpeed))
			
			

func StaminaRefill():
	
	stats.Stamina = move_toward(stats.Stamina, stats.MaxStamina, 5.0)
	print(Stamina)
	if stats.Stamina != stats.MaxStamina:
		timer.start()
func StaminaChanged():
	print("stopped")
	timer.stop()
	sectimer.start()
	
	



	



	

func StaminaSet(value):
	emit_signal("ChangedStamina")
	

func _on_HurtBox_area_entered(area):
	emit_signal("health_update")
	stats.Health -= 10
	 

func _on_PlayerStats_healthChange():
	
	health = stats.Health
	


func _on_PlayerStats_staminaChange():
	Stamina = stats.Stamina
	if stats.Stamina != stats.MaxStamina:
		StaminaChanged() # Replace with function body.


func _on_Timer2_timeout():
	print("refill2")
	timer.start() # Replace with function body.


func _on_Timer_timeout():
	print(Stamina)
	StaminaRefill()# Replace with function body.
