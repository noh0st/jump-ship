extends TextureProgress


# this is just UI. the entity still owns it's own health.


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_ui(health: int, max_health: int) -> void:
	if(health == max_health):
		self.visible = false
	elif(health != max_health):
		self.visible = true
		
	self.value = health * 100 / max_health 
