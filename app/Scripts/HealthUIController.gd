extends CanvasLayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var staminabar = $StaminaBar
onready var BoidsLabel = $BoidsNum
onready var xpbar = $XPBar

export var _is_ready: bool = false

var _player: Node # the plyaer

# Called when the node enters the scene tree for the first time.
func init(player: Node) -> void:
	_player = player
	
	$XPBar.visible = true
	$BossHealthBar.visible = false
	
	PlayerStats.connect("healthChange",self, "_on_Player_health_update")
	PlayerStats.connect("staminaChange",self, "_on_Player_ChangedStamina")
	PlayerStats.connect("xpChange",self, "_on_PlayerStats_xpChange")
	
	$BoidsNum.text = "%s" % _player.flock_size()
	
	staminabar.value = PlayerStats.Stamina / (PlayerStats.MaxStamina/100)
	
	update_xp(0, 0)
	
	print(BoidsLabel)
	_is_ready = true
	$POPUP_Tutorial.StartTutorial()

func enable_boss_health_bar() -> void:
	$XPBar.visible = false
	$BossHealthBar.visible = true
	$POPUP_Tutorial.StartBossFight()

func reset() -> void:
	$XPBar.visible = true
	$BossHealthBar.visible = false


func _on_Player_ChangedStamina(value):
	staminabar.value = value / (PlayerStats.MaxStamina/100)


func _on_Player_player_boid_count_update(new_value):
	if not _is_ready:
		return
	
	print("player boid update")
	print(BoidsLabel)
	print($BoidsNum)
	# PlayerStats.BoidsCollectedNum = new_value
	BoidsLabel.text = "%s" % new_value
	

func update_xp(xp: int, max_xp: int) -> void:
	xpbar.max_value = max_xp
	xpbar.value = xp
	$XPBar/XP.text = str(xp)
	$XPBar/MaxXP.text = str(max_xp)

