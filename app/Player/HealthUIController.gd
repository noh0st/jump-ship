extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var healthLabel: Label = get_node("HealthLabel")
onready var staminaLabel: Label = get_node("StaminaLabel")
onready var player = get_tree().get_root().find_node("Player", true, false)
# Called when the node enters the scene tree for the first time.
func _ready():
	
	healthLabel.text = "Health: %s" % 100
	staminaLabel.text = "Stamina: %s" % 100
	player.connect("ChangedStamina", self, "SetStaminaText")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Player_health_update(amount: int) -> void:
	healthLabel.text = "Health: %d" % amount
func SetStaminaText():
	pass
