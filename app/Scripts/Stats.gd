extends Node
#_____________________#

signal Death
signal healthChange(value)
signal staminaChange(value)
signal boidsChange(value)
#_____________________#

var BoidsCollectedNum setget BoidsChanged
var Stamina setget ChangedStamina
var Health = 10 setget ChangedHealth

#_____________________#
var staminaForDash = 10
var BoidHealthNum = 0

var MaxStamina = 100
var staminaRegen = 5
export var HealthPerBoid = 10
var FollowingBoids = []
#_____________________#

func BoidsChanged(value): # change the value of the number of boids you get
	BoidsCollectedNum = value
	BoidHealthNum = value
	emit_signal("boidsChange", BoidsCollectedNum)
	Health = (BoidHealthNum * HealthPerBoid) + 10

	BoidHealthNum = 0
	emit_signal("healthChange", Health)
#set stats to their maximum at the start of the game
func _ready():
	BoidsCollectedNum = 0
	Health = 10
	Stamina = MaxStamina
	#####
# emits signals if any stat get set
func ChangedHealth(value):
	if value > 0:
		Health = value
	elif value <= 0:
		Health = 0
		print("EmitDeath")
		emit_signal("Death")
		
	emit_signal("healthChange", Health)
	#######
func ChangedStamina(value):
	
	Stamina = value
	
	emit_signal("staminaChange", Stamina)
