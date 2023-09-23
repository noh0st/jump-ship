extends Node
signal healthChange
signal staminaChange
var Health setget ChangedHealth
var staminaForDash = 10
var MaxHealth = 100
var Stamina setget ChangedStamina
var MaxStamina = 100
var staminaRegen = 5
#set stats to their maximum at the start of the game
func _ready():
	Health = MaxHealth
	Stamina = MaxStamina
	#####
# emits signals if any stat get set
func ChangedHealth(value):
	if value > 0:
		Health = value
	elif value <= 0:
		Health = 0
		
	emit_signal("healthChange")
	#######
func ChangedStamina(value):
	
	Stamina = value
	emit_signal("staminaChange")
