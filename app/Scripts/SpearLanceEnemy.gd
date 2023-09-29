extends KinematicBody2D


var TargetPos: Vector2
var Velocity := Vector2.ZERO
var Target : Area2D

var Dir := Vector2.ZERO
var HasTarget := false
onready var _animationPlayer = $AnimationPlayer
onready var _attackTimer = $re_AttackTimer
onready var _patrolTimer = $patrolTimer
var MoveTowardsTarget := false
func _ready():
	set_meta("SpearLanceEnemy", false)

	Velocity = TargetPos - self.position
	_animationPlayer.play("Idle")
func _on_Vision_area_entered(area):
	
	if area.get_parent().has_meta("SpearLanceEnemy"):
		pass
	elif area.get_parent().has_meta("Player"):
		Target = area
		MoveTowardsTarget = true
		HasTarget = true
		_patrolTimer.stop()
		
		
func _physics_process(delta):
	Move()

	
func _on_AttackRange_area_entered(area):
	if area.get_parent().has_meta("Player"):
		Attack()
		Velocity=Vector2.ZERO
		MoveTowardsTarget = false

##########
func AttackDir():
	Dir = (Target.get_parent().position - self.position).normalized()
	print(Dir)
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
	Velocity=Vector2.ZERO
	Dir = Velocity.normalized()
	AttackDir()
	_attackTimer.start(0)

	
func Move():

	if Target != null:
		if HasTarget == true :
			if MoveTowardsTarget:
				Velocity = Target.get_parent().position - self.position 
				MovementDir()
				move_and_slide(Dir * 70)
			Dir = Velocity.normalized()
			
			
	if HasTarget == false:
		
		Dir = Velocity.normalized()
		MovementDir()
		move_and_slide(Dir* 70)
onready var AttackNum := 0	
func _on_re_AttackTimer_timeout():
	Attack()

	AttackNum += 1
	if AttackNum > 3:
		AttackNum = 0
		_attackTimer.wait_time = _attackTimer.wait_time - 0.2
#############

func _on_AttackRange_area_exited(area):
	if area == Target:
		_attackTimer.stop()

		MoveTowardsTarget = true


func _random_direction() -> Vector2:
	
	TargetPos.x = rand_range(self.position.x - 300, self.position.x + 300 )
	TargetPos.y = rand_range(self.position.y - 300, self.position.y + 300 )
	 
	return TargetPos
	
func _on_Vision_area_exited(area):
	if area == Target:
		Target = null
		HasTarget = false
		MoveTowardsTarget = false
		_patrolTimer.start(0)
		Velocity = TargetPos - self.position

func _on_patrolTimer_timeout():
	print(TargetPos, " hi ")
	_random_direction()
	Velocity = TargetPos - self.position
