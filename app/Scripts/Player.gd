extends KinematicBody2D
# Variables And Signals#


signal ChangedStamina(value)
signal health_update(new_value)
signal xp_update(new_value)
signal player_boid_count_update(new_value)
signal PlayerDeath
#_____________________#

onready var _enemy_manager = get_node("/root/Main/YSort/EnemyManager")

const MaxSpeed = 250.0
const Acceleration_Friction = 20.0
const DashPower = 5
#_____________________#

var velocity = Vector2.ZERO
var Dir: Vector2
var IsIdle = true

#_____________________#
onready var timer = $StaminaTimer
onready var _animation_player = $AnimationPlayer
onready var boid_flock = $BoidFlock
export var initialBoidNum := 3
#_____________________#
func _onready():
	PlayerStats.Stamina = PlayerStats.MaxStamina # set stamina to the max value of stamina in the stats script


#_____________________#
func _ready():
	IsIdle = true
	boid_flock.owner = self
	for i in range(0, initialBoidNum):
		boid_flock.spawn_boid()
		i += 1
	$HurtEffect.modulate = 0
	$Sprite.modulate = Color( 1, 1, 1, 1 )
	self.set_meta("Player", true)
	_animation_player.play("Idle")
	
	$BoidAbsorptionComponent.init(_enemy_manager)
	
	_enemy_manager.subscribe_to_deaths(funcref(self, "_on_enemy_death"))
	
	
func add_damage(value: int, knockback_dealer: Node) -> void:
	#PlayerStats.Health -= value
	# release boid
	boid_flock.release_boid();
	_animation_player.play("Hurt")
	if _enemy_manager._enemies.has(knockback_dealer):
		move_and_slide(Vector2(PlayerStats.globalSelfKnockBack * (self.position.x - knockback_dealer.position.x), PlayerStats.globalSelfKnockBack * (self.position.y - knockback_dealer.position.y)))
	
	
func _on_enemy_death(enemy: Node) -> void: # this can take the enemy as a param to get xp per enemy
	emit_signal("xp_update", enemy.xp_worth)
	$XPSFX.play()
	
func add_boid() -> void:
	boid_flock.spawn_boid()
	
	
func flock_size() -> int:
	return boid_flock.size()
		
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
	if inputvector != Vector2.ZERO && CanMove:
		velocity = inputvector.normalized() * MaxSpeed * delta # acceleration 
		Dir = inputvector # Direction vector for setting the look direction of player
		if $WalkingCycle.time_left <= 0:
			$FootStepSFX.stream = load("res://SFX/MX Footsteps_1.wav")
			$FootStepSFX.pitch_scale = rand_range(0.8, 1.2)
			$FootStepSFX.play()
			$WalkingCycle.start(0.2)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, Acceleration_Friction* delta) # deceleration
	

	PlayRunAnimationDirection(inputvector)
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
			$DashSFX.play()
			move_and_slide(Dir * (DashPower * MaxSpeed)) # move in the direction you are facing
			
			
#_____________________#
# Function to refill stamina
func StaminaRefill():
	PlayerStats.Stamina = move_toward(PlayerStats.Stamina, PlayerStats.MaxStamina, PlayerStats.staminaRegen) # regen stamina
	
	if PlayerStats.Stamina != PlayerStats.MaxStamina: # if stamina is not full, start recovering stamina again
		timer.start() 


func PlayRunAnimationDirection(direction: Vector2):
	if CanMove:
		if direction.x > 0:
			IsIdle = false
			_animation_player.play("WalkRight")
		elif direction.x < 0:
			IsIdle = false
			_animation_player.play("WalkLeft")
		elif direction.length() > 0:
			IsIdle = false
			_animation_player.play("Walk")
		else:
			IsIdle = true
		
	
#_____________________#
# Hurt player if enemy enters
	
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
	

func _on_BoidFlock_boid_count_update(new_value):
	print("emiting boid")
	emit_signal("player_boid_count_update", new_value)


func _on_HurtBox_area_entered(area):
	pass # Replace with function body.



func _on_AnimationPlayer_animation_finished(anim_name):
	if IsIdle == true:
		_animation_player.play("Idle")
	if anim_name == "Hurt":
		CanMove = true
		
export(Array , AudioStreamSample) var FootStepSoundsArray : Array
var AvailableFootStepSounds = []
func _on_WalkingCycle_timeout():
	AvailableFootStepSounds.append_array(FootStepSoundsArray)
	AvailableFootStepSounds.remove(AvailableFootStepSounds.find($FootStepSFX.stream))
	$FootStepSFX.stream = AvailableFootStepSounds[randi() % AvailableFootStepSounds.size()]
	AvailableFootStepSounds.append_array(FootStepSoundsArray)
	print($FootStepSFX.stream)

var CanMove = true
func _on_AnimationPlayer_animation_started(anim_name):
	if anim_name == "Hurt":

		CanMove = false

