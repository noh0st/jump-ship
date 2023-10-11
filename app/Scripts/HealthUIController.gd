extends CanvasLayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var hpbar = $HPBar
onready var staminabar = $StaminaBar
onready var BoidsLabel = $BoidsNum
onready var xpbar = $XPBar

export var _is_ready : bool = false

# Called when the node enters the scene tree for the first time.
func init(player: Node) -> void:
	
	PlayerStats.connect("healthChange",self, "_on_Player_health_update")
	PlayerStats.connect("staminaChange",self, "_on_Player_ChangedStamina")
	PlayerStats.connect("xpChange",self, "_on_PlayerStats_xpChange")
	
	$BoidsNum.text = "Number Of Followers : %s" % player.flock_size()
	
	staminabar.value = PlayerStats.Stamina/ (PlayerStats.MaxStamina/100)
	xpbar.value = 0
	$XPBar/XP.text = "0"
	$XPBar/MaxXP.text = str(PlayerStats.MaxXP)
	
	print(BoidsLabel)
	_is_ready = true


func _on_Player_ChangedStamina(value):
	staminabar.value = value / (PlayerStats.MaxStamina/100)


func _on_Player_player_boid_count_update(new_value):
	if not _is_ready:
		return
	
	print("player boid update")
	print(BoidsLabel)
	print($BoidsNum)
	# PlayerStats.BoidsCollectedNum = new_value
	BoidsLabel.text = "Number Of Followers : %s" % new_value
	
	
func _on_PlayerStats_xpChange(new_value):
	xpbar.max_value = PlayerStats.MaxXP
	xpbar.value = new_value
	$XPBar/XP.text = str(PlayerStats.XP )
	$XPBar/MaxXP.text = str(PlayerStats.MaxXP)
