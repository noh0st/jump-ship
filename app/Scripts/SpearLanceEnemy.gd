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
	set_meta("Enemy", false)
	
	Velocity = TargetPos - self.position
	_animationPlayer.play("Idle")
	
func _on_Vision_area_entered(area): #if you dont have target, set a target
	if HasTarget == false: 
		
		if area.get_parent().has_meta("Player") or area.get_parent().has_meta("Boid"):
			Target = area
			
			MoveTowardsTarget = true
			HasTarget = true
			_patrolTimer.stop()
	
		
func _physics_process(delta): #Target death
	if Target != null && Target.get_parent().has_meta("Boid"):
		if !BoidsGlobal.AllBoidsArray.has(Target.get_parent()):
			TargetDead()
			
	Move() # movement
	
func TargetDead(): #what to do when target dies
	
	Target = null
	HasTarget = false
	MoveTowardsTarget = false
	_patrolTimer.start(0)
	Velocity = TargetPos - self.position
	
	
func _on_AttackRange_area_entered(area): #if entered the attack range attacks, 
	#whether you are target or not, as long as you are a player or boid attacks, can be changed
	if area.get_parent().has_meta("Player") or area.get_parent().has_meta("Boid"):
		Attack()
		Velocity=Vector2.ZERO
		MoveTowardsTarget = false

##########
func AttackDir():
	#find direction of attack
	if Target.get_parent() != null:
		Dir = (Target.get_parent().position - self.position).normalized()

	if Dir.x >= 0:
		_animationPlayer.play("AttackRight")
	elif Dir.x < 0:
		_animationPlayer.play("AttackLeft")
func MovementDir():
	#find direction of movement
	$HitBoxPivot/Area2D/CollisionShape2D.disabled = true
	if Dir.x >= 0:
		
		_animationPlayer.play("RunRight")
	elif Dir.x < 0:
		_animationPlayer.play("RunLeft")
##########

func Attack():
	#attacking - stops the attacks, the hitboxes are controlled through the animation player
	if Target != null:
		Velocity=Vector2.ZERO
		Dir = Velocity.normalized()
		AttackDir()
		_attackTimer.start(0)
	if Target == null:
		_attackTimer.stop()
		
func Move():
	# how to move, if have target move towards, else patrol in a random direction
	if Target != null:
		if HasTarget == true :
			if MoveTowardsTarget:
				Velocity = Target.get_parent().position - self.position 
				MovementDir()
				move_and_slide(Dir * 100)
			Dir = Velocity.normalized()
			
			
	if HasTarget == false:
		
		Dir = Velocity.normalized()
		MovementDir()
		move_and_slide(Dir* 100)
		
onready var AttackNum := 0	
func _on_re_AttackTimer_timeout():
	#attacking , won't stop unless you exit the attacking range
	Attack()

	AttackNum += 1
	if AttackNum > 3:
		AttackNum = 0
		_attackTimer.wait_time = _attackTimer.wait_time - 0.2
#############

func _on_AttackRange_area_exited(area):# if you exit, stops attacking and follows you
	if area == Target:
		_attackTimer.stop()

		MoveTowardsTarget = true


func _random_direction() -> Vector2:
	#random patrol direction movement
	TargetPos.x = rand_range(self.position.x - 300, self.position.x + 300 )
	TargetPos.y = rand_range(self.position.y - 300, self.position.y + 300 )
	 
	return TargetPos
	
func _on_Vision_area_exited(area):#if exited vision, immedietly lost aggro
	if area == Target:
		Target = null
		HasTarget = false
		MoveTowardsTarget = false
		_patrolTimer.start(0)
		Velocity = TargetPos - self.position

func _on_patrolTimer_timeout():
	#change patrol direction every few seconds
	_random_direction()
	Velocity = TargetPos - self.position
