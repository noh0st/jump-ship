extends Node

var _cb: FuncRef

export var HpRegen : float
func _ready():
	$Area2D/CollisionShape2D.disabled = false
	
	
func _on_Area2D_area_entered(area):
	if area.get_parent().has_method("AppleHeal"):
		area.get_parent().AppleHeal(HpRegen)
		$AnimationPlayer.play("ApplePickup")
		
		
func init(cb: FuncRef) -> void:		
	_cb = cb


func _on_AnimationPlayer_animation_finished(anim_name):
	if _cb.is_valid():
		_cb.call_func(self)
	
	self.queue_free() # Replace with function body.
	
