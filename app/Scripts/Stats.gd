extends Node
var defValuesDic = {
	"defHealth" : 100,
	"defStamina" : 100,
	"defBoidsNum" : 0,
	"defFollowingBoids" : [],
}
#_____________________#

signal Death
signal healthChange(value)
signal staminaChange(value)
signal boidsChange(value)
#_____________________#

var BoidsCollectedNum setget BoidsChanged
var Stamina setget ChangedStamina
var Health :int setget ChangedHealth

var FollowingBoids = [] 


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

func ResetValues():
	Health = defValuesDic["defHealth"]
	Stamina = defValuesDic["defStamina"]
	BoidsCollectedNum = defValuesDic["defBoidsNum"] 
	FollowingBoids = defValuesDic["defFollowingBoids"]
