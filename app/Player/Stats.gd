extends Node
signal healthChange
signal staminaChange
var Health setget ChangedHealth
var staminaForDash = 10
var MaxHealth = 100
var Stamina setget ChangedStamina
var MaxStamina = 100
func _ready():
	Health = MaxHealth
	Stamina = MaxStamina
	#####
func ChangedHealth(value):
	Health = value
	emit_signal("healthChange")
	#######
func ChangedStamina(value):
	
	Stamina = value
	emit_signal("staminaChange")
