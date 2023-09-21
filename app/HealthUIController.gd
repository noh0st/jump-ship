extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var healthLabel: Label = get_node("HealthLabel")

# Called when the node enters the scene tree for the first time.
func _ready():
	healthLabel.text = "Health: %s" % 100

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Player_health_update(amount: int) -> void:
	healthLabel.text = "Health: %d" % amount
