extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var hpbar = $HPBar
onready var staminabar = $StaminaBar
onready var BoidsLabel = $BoidsNum
onready var xpbar = $XPBar
# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerStats.connect("healthChange",self, "_on_Player_health_update")
	PlayerStats.connect("staminaChange",self, "_on_Player_ChangedStamina")
	PlayerStats.connect("boidsChange",self, "_on_PlayerStats_boidsChange")
	PlayerStats.connect("xpChange",self, "_on_PlayerStats_xpChange")
	hpbar.value = PlayerStats.Health/ (PlayerStats.MaxHealth/100)
	staminabar.value = PlayerStats.Stamina/ (PlayerStats.MaxStamina/100)
	xpbar.value = 0
	BoidsLabel.text = "Number Of Followers : %s" % PlayerStats.BoidsCollectedNum	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
	

func _on_Player_health_update(new_value):
	hpbar.value = new_value / (PlayerStats.MaxHealth/100)
	

func _on_Player_ChangedStamina(value):
	staminabar.value = value / (PlayerStats.MaxStamina/100)


func _on_Player_player_boid_count_update(new_value):
	print("player boid update")
	PlayerStats.BoidsCollectedNum = new_value
	BoidsLabel.text = "Number Of Followers : %s" % PlayerStats.BoidsCollectedNum
func _on_PlayerStats_xpChange(new_value):
	xpbar.value = new_value
