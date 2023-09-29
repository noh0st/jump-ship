extends KinematicBody2D
# Variables And Signals#


signal ChangedStamina(value)
signal health_update(new_value)
signal PlayerDeath
#_____________________#

const MaxSpeed = 500.0
const Acceleration_Friction = 50
const DashPower = 5
#_____________________#

var velocity = Vector2.ZERO
var Dir: Vector2

#_____________________#
onready var timer = $StaminaTimer
onready var sectimer = $StaminaRegenPause
onready var animationPlayer = $AnimationPlayer
onready var animationTree = $AnimationTree
#_____________________#
func _onready():
	PlayerStats.Stamina = PlayerStats.MaxStamina # set stamina to the max value of stamina in the stats script


#_____________________#
func _ready():
	self.set_meta("Player", true)
	
#_____________________#
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	#_____________________#
	# Getting the inputs, 1 for right, -1 for left, 1 for up, -1 for down (Horizontal, Vertical)
	var inputvector : Vector2 = Vector2.ZERO
	if Dir == Vector2.ZERO:
		Dir = Vector2(1, 0)
	inputvector.x = Input.get_action_strength("MovementRight") - Input.get_action_strength("MovementLeft")
	inputvector.y = Input.get_action_strength("MovementDown") - Input.get_action_strength("MovementUp")
	#_____________________#
	
		
			
	#_____________________#
	#Check if player is inputing values, move the player based on those values
	if inputvector != Vector2.ZERO:
		
		velocity += inputvector.normalized() * Acceleration_Friction * delta # acceleration 
		velocity = velocity.clamped(MaxSpeed*delta)
		Dir = inputvector # Direction vector for setting the look direction of player
		animationTree.set("parameters/Idle/blend_position", Dir) # change direction player is facing based on "Dir" value
	else:
		velocity = velocity.move_toward(Vector2.ZERO, Acceleration_Friction* delta) # deceleration
	

	move_and_collide(velocity) # movement
	#_____________________#
	Dash() # Dash function
#_____________________#
#Dash Function
func Dash(): 
	if  Input.is_action_just_pressed("Dash") == true :
		
		if PlayerStats.Stamina >= PlayerStats.staminaForDash:
			PlayerStats.Stamina -= PlayerStats.staminaForDash; 
			timer.start()  # start timer for stamina recovering

			move_and_slide(Dir * (DashPower * MaxSpeed)) # move in the direction you are facing
			
			
#_____________________#
# Function to refill stamina
func StaminaRefill():
	
	PlayerStats.Stamina = move_toward(PlayerStats.Stamina, PlayerStats.MaxStamina, PlayerStats.staminaRegen) # regen stamina
	
	if PlayerStats.Stamina != PlayerStats.MaxStamina: # if stamina is not full, start recovering stamina again
		timer.start() 
	
#_____________________#
# Hurt player if enemy enters
func _on_HurtBox_area_entered(area):
	PlayerStats.Health -= 10 

	
	 
#_____________________#
# Signal from stats,  if the health stats ever changes this function starts
func _on_PlayerStats_healthChange(value):
	
		emit_signal("health_update", PlayerStats.Health)
		
#_____________________#
# Signal from stats,  if the stamina stats ever changes this function starts


#_____________________#
# If stamina timer runs out, regen stamina 
func _on_Timer_timeout():
	
	StaminaRefill()# Replace with function body.

