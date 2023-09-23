extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var healthLabel = $HealthLabel
onready var staminaLabel = $StaminaLabel
onready var BoidsLabel = $BoidsNum
# Called when the node enters the scene tree for the first time.
func _ready():
	
	healthLabel.text = "Health: %s" % PlayerStats.Health
	staminaLabel.text = "Stamina: %s" % PlayerStats.Stamina
	BoidsLabel.text = "Number Of Followers : %s" % PlayerStats.BoidsCollectedNum	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Player_health_update(new_value):

	healthLabel.text = "Health: %d" % new_value 
	
	print(new_value)

func _on_Player_ChangedStamina(value):

	staminaLabel.text = "Stamina: %d" % value 


func _on_PlayerStats_boidsChange(value):
	BoidsLabel.text = "Number Of Followers : %s" % PlayerStats.BoidsCollectedNum
	print(PlayerStats.BoidsCollectedNum)

