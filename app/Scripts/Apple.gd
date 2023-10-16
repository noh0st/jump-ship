extends Node

var _cb: FuncRef

export var HpRegen : float
func _ready():
	$Area2D/CollisionShape2D.disabled = false
	
	
func _on_Area2D_area_entered(area):
	print("APPLE ENTERRED")
	print(area.get_parent())
	if area.get_parent().has_method("AppleHeal"):
		print("APPLE ENTERRED")
		print(area.get_parent())
		
		area.get_parent().AppleHeal(HpRegen)
		print("Heal")
		$AnimationPlayer.play("ApplePickup")
		
		
func init(cb: FuncRef) -> void:		
	_cb = cb


func _on_AnimationPlayer_animation_finished(anim_name):
	if _cb.is_valid():
		_cb.call_func(self)
	
	self.queue_free() # Replace with function body.
	
