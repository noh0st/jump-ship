extends KinematicBody2D


var TargetPos: Vector2
var Velocity := Vector2.ZERO
var Target : Vector2
var TargetArea : Area2D
var Dir := Vector2.ZERO
var HasTarget := false
onready var _animationPlayer = $AnimationPlayer
onready var _attackTimer = $re_AttackTimer
func _ready():
	set_meta("SpearLanceEnemy", false)
	set_physics_process(false)

func _on_Vision_area_entered(area):

	if area.get_parent().has_meta("SpearLanceEnemy"):
		pass
	elif area.get_parent().has_meta("Player"):
		Target = area.get_parent().position
		TargetArea = area
		HasTarget = true
		set_physics_process(true)
		
		
func _physics_process(delta):
	Move()
	
	
func _on_AttackRange_area_entered(area):
	if area.get_parent().has_meta("Player"):
		Attack()
		
##########
func AttackDir():
	if Dir.x >= 0:
		_animationPlayer.play("AttackRight")
	elif Dir.x < 0:
		_animationPlayer.play("AttackLeft")
func MovementDir():
	if Dir.x >= 0:
		_animationPlayer.play("RunRight")
	elif Dir.x < 0:
		_animationPlayer.play("RunLeft")
##########

func Attack():
	
	set_physics_process(false)
	AttackDir()
	_attackTimer.start(0)
	
func Move():
	
	if Target != null:
		if HasTarget == true :
			Velocity = Target - self.position 
			Dir = Velocity.normalized()
			MovementDir()
			move_and_slide(Velocity)
	if HasTarget == false:
		Dir = Velocity.normalized()
		MovementDir()
		move_and_slide(Velocity)
		if self.position == TargetPos:
			TargetPos = _random_direction()
func _on_re_AttackTimer_timeout():
	Attack()
	
#############

func _on_AttackRange_area_exited(area):
	if area == TargetArea:
		_attackTimer.stop()
		set_physics_process(true)


func _random_direction() -> Vector2:
	TargetPos.x = rand_range(self.position.x - 10, self.position.x + 10 )
	TargetPos.y = rand_range(self.position.y - 10, self.position.y + 10 )
	return TargetPos
	
func _on_Vision_area_exited(area):
	if area == TargetArea:
		TargetArea = null
		HasTarget = false
		
		if HasTarget == false:
			if self.position != _random_direction():
				print(Velocity)
				Velocity = _random_direction() - self.position 
			
