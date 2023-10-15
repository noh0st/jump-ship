extends Node2D


export var HpRegen : float
func _ready():
	$Area2D/CollisionShape2D.disabled = false
func _on_Area2D_area_entered(area):
	if area.get_parent().has_method("AppleHeal") and (not area.get_parent().has_meta("Enemy")):
		area.get_parent().AppleHeal(HpRegen)
		print("Heal")
		$AnimationPlayer.play("ApplePickup")
		


func _on_AnimationPlayer_animation_finished(anim_name):
	self.queue_free() # Replace with function body.
