extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var healthLabel = $HealthLabel
onready var staminaLaber = $StaminaLabel
# Called when the node enters the scene tree for the first time.
func _ready():
	healthLabel.text = "Health: %s" % 100
	staminaLaber.text = "Stamina: %s" % 100	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Player_health_update(new_value):
	print(new_value)
	healthLabel.text = "Health: %d" % new_value # Replace with function body.


func _on_Player_ChangedStamina(value):
	print(value)
	staminaLaber.text = "Stamina: %d" % value # Replace with function body.
