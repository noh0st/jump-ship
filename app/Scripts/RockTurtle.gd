extends Node2D


var Target: Area2D
var TargetDir: Vector2
var HasTarget := false
onready var attackAnimationPlayer = $AnimationPlayer
onready var attackTimer = $AttackTimer
onready var _sprite = $Sprite
func _ready():
	_sprite = "res://Assets/01.png"
func _process(delta):
	if Target != null:
		TargetDir = self.position - Target.position
		
func _on_TurtleVision_area_entered(area):
	if HasTarget == false:
		Target = area
		HasTarget = true
		
		attackTimer.start(0)
		print(TargetDir, area)
		


func _on_TurtleVision_area_exited(area):
	if area == Target:
		if HasTarget == true:
			attackTimer.stop()
			Target = null
			HasTarget = false
			




func _on_AttackTimer_timeout():
	attackAnimationPlayer.play("RockTurtleAttack")


func _on_AnimationPlayer_animation_finished(anim_name):
	print("done")
	Target = null
	HasTarget = false


func _on_DamageZone_area_entered(area):
	pass
