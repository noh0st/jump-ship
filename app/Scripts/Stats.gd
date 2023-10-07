extends Node

#_____________________#

signal Death
signal healthChange(value)
signal staminaChange(value)
signal boidsChange(value)
signal xpChange(value)
signal newLevel()
#_____________________#

var BoidsCollectedNum setget BoidsChanged
var Stamina setget ChangedStamina
var Health :int setget ChangedHealth
var XP setget ChangedXP
#_____________________#
var staminaForDash = 10

var MaxHealth := 100
var MaxStamina = 100
var staminaRegen = 5
export var HealthPerBoid = 10

#_____________________#

func BoidsChanged(value): # change the value of the number of boids you get
	BoidsCollectedNum = value
	
	emit_signal("boidsChange", BoidsCollectedNum)
	emit_signal("healthChange", Health)
	
	
#set stats to their maximum at the start of the game
func _ready():
	BoidsCollectedNum = 0
	Health = MaxHealth
	Stamina = MaxStamina
	#####
	XP = 0
	
# emits signals if any stat get set
func ChangedHealth(value):
	if value > 0:
		Health = value
	elif value <= 0:
		Health = 0
		emit_signal("Death")
		
	emit_signal("healthChange", Health)
	#######
	
	
func ChangedStamina(value):
	Stamina = value
	emit_signal("staminaChange", Stamina)
	
func ChangedXP(value):
	XP = value
	print(XP)
	emit_signal("xpChange", XP)
	if XP >= 100:
		XP = 0
		ChangedXP(XP)
		emit_signal("newLevel")
func ResetValues():
	Health = MaxHealth
	Stamina = MaxStamina
	BoidsCollectedNum = 3
func UpgradedValues():
	MaxHealth= GlobalUpgradeStats.globalSelfHealth
	MaxStamina = GlobalUpgradeStats.playerStamina
	Health = MaxHealth
	Stamina = MaxStamina
