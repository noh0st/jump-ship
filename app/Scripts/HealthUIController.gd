extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var hpbar = $HPBar
onready var staminabar = $StaminaBar
onready var BoidsLabel = $BoidsNum
# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerStats.connect("healthChange",self, "_on_Player_health_update")
	PlayerStats.connect("staminaChange",self, "_on_Player_ChangedStamina")
	PlayerStats.connect("boidsChange",self, "_on_PlayerStats_boidsChange")
	hpbar.value = PlayerStats.Health
	staminabar.value = PlayerStats.Stamina
	BoidsLabel.text = "Number Of Followers : %s" % PlayerStats.BoidsCollectedNum	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
	

func _on_Player_health_update(new_value):
	
	hpbar.value  =new_value 
	


func _on_Player_ChangedStamina(value):

	staminabar.value = value 


func _on_PlayerStats_boidsChange(value):
	BoidsLabel.text = "Number Of Followers : %s" % PlayerStats.BoidsCollectedNum


