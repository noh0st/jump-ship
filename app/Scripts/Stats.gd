extends Node

#_____________________#

signal Death
signal healthChange(value)
signal staminaChange(value)
signal boidsChange(value)
signal newLevel()
#_____________________#

#var BoidsCollectedNum setget BoidsChanged
var Stamina setget ChangedStamina
#var Health :int setget ChangedHealth
#_____________________#
var staminaForDash = 10

var MaxHealth := 100
export var MaxXpMultiplyer: float = 2
var MaxStamina = 100
var staminaRegen = 5
export var HealthPerBoid = 10
export var globalSelfKnockBack: float = 20
#_____________________#

func BoidsChanged(value): # change the value of the number of boids you get
	pass #BoidsCollectedNum = value
	
	#emit_signal("boidsChange", BoidsCollectedNum)
	#emit_signal("healthChange", Health)
	
	
#set stats to their maximum at the start of the game
func _ready():
	# BoidsCollectedNum = 0
	#Health = MaxHealth
	Stamina = MaxStamina
	#####
	#XP = 0
	
# emits signals if any stat get set
func ChangedHealth(value):
	if value > 0:
		pass #Health = value
	elif value <= 0:
		#Health = 0
		emit_signal("Death")
		
	#emit_signal("healthChange", Health)
	#######
	
	
func ChangedStamina(value):
	Stamina = value
	emit_signal("staminaChange", Stamina)
	
		
func ResetValues():
	#Health = MaxHealth
	Stamina = MaxStamina
	# BoidsCollectedNum = 3
	
	
func UpgradedValues():
	MaxHealth= GlobalUpgradeStats.globalSelfHealth
	MaxStamina = GlobalUpgradeStats.playerStamina
	#Health = MaxHealth
	Stamina = MaxStamina
