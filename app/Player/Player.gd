extends KinematicBody2D

signal health_update(new_value)

var velocity = Vector2.ZERO
const MaxSpeed = 500.0
const Acceleration_Friction = 20.0
const DashPower = 5

var Stamina

signal ChangedStamina(value)


var Dir: Vector2
onready var timer = $StaminaTimer
onready var sectimer = $StaminaRegenPause
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

			move_and_slide(Dir * (DashPower * MaxSpeed))
			
			

func StaminaRefill():
	
	stats.Stamina = move_toward(stats.Stamina, stats.MaxStamina, 5.0)

	if stats.Stamina != stats.MaxStamina:
		timer.start()

func _on_HurtBox_area_entered(area):
	stats.Health -= 10

	
	 

func _on_PlayerStats_healthChange():
	
	health = stats.Health
	
	if health <= 0:
		health = 0
		emit_signal("health_update", health)
		queue_free()
	else:
		emit_signal("health_update", health)

func _on_PlayerStats_staminaChange():
	Stamina = stats.Stamina
	emit_signal("ChangedStamina", Stamina)

	


func _on_Timer_timeout():
	
	StaminaRefill()# Replace with function body.
