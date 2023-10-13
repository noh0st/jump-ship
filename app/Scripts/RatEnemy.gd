extends KinematicBody2D


var Target : Node
var Dir := Vector2.ZERO


onready var _animationPlayer = $AnimationPlayer
onready var _cooldownTimer = $re_AttackTimer
onready var _patrolTimer = $patrolTimer

onready var _current_state: int = State.PATROLLING setget set_current_state
onready var _attack_state: int = AttackState.COOLING setget set_attack_state

enum State {
	PATROLLING,
	APPROACHING,
	ATTACKING,
	RETREATING
}

enum AttackState {
	ATTACKING,
	COOLING
}


func _ready():
	set_meta("Enemy", false)
	
	self._current_state = State.PATROLLING
	
	_animationPlayer.play("Idle")
	
const VISION_RANGE: int = 250
const ATTACK_RANGE: int = 50

	
func _physics_process(delta): #Target death
	match _current_state:
		State.PATROLLING:
			var speed = 100
			PlayRunAnimationDirection(Dir)
			move_and_slide(Dir * speed)
		State.APPROACHING:
			process_approaching(delta)
		State.ATTACKING:
			process_attacking(delta)
			
	
func process_approaching(delta) -> void:
	if not (is_instance_valid(Target)):
		print(Target)
		print("target not valid - approaching")
		if not _check_vision_and_set_target():
			self._current_state = State.PATROLLING
		return
	
	if Target.position.distance_to(position) > VISION_RANGE:
		print("target out of range")
		if not _check_vision_and_set_target():
			self._current_state = State.PATROLLING
		return

	if Target.position.distance_to(position) < ATTACK_RANGE:
		print("APPROACH IN RANGE")
		self._current_state = State.ATTACKING
		return
		
	var direction = (Target.position - position).normalized()
	Dir = direction
	
	var leap_direction = direction
	var leap_speed = 200
	PlayLeapAnimationDirection(direction)
	move_and_slide(leap_speed * leap_direction)
func process_attacking(delta) -> void:
	match _attack_state:
		AttackState.ATTACKING:
			pass
		AttackState.COOLING:
			pass
			

func set_current_state(value: int) -> void:
	match value:
		State.PATROLLING:
			if _current_state == value:
				return
			
			_current_state = value
			
			Dir = _random_direction()
			Target = null

			_patrolTimer.start()
			_cooldownTimer.stop()
		State.APPROACHING:
			if _current_state == value:
				return
			
			_current_state = value
			
			_cooldownTimer.stop()
			_patrolTimer.stop()
		State.ATTACKING:					
			_current_state = value
			self._attack_state = AttackState.ATTACKING
			Dir = Vector2(0,0)
			
	$DebugUI/Text.text = "state: %d \nattack_state %d" % [_current_state, _attack_state]
	
			
func set_attack_state(value: int) -> void:
	if _attack_state == value:
		return
	
	_attack_state = value
	
	$DebugUI/Text.text = "state: %d \nattack_state %d" % [_current_state, _attack_state]
	
	match value:
		AttackState.ATTACKING:

			#$HitBoxPivot/Area2D/CollisionShape2D.set_deferred("disabled",  true)
			#$Vision/CollisionShape2D.set_deferred("disabled",  false)
			
			PlayAttackAnimation()
		AttackState.COOLING:

			
			#$Vision/CollisionShape2D.set_deferred("disabled",  true)
			$HitBoxPivot/Area2D/CollisionShape2D.set_deferred("disabled",  true)
			_cooldownTimer.start(2.0)
			pass

##########
func PlayAttackAnimation():
	#find direction of attack
	if not (is_instance_valid(Target)):
		return
		
	var direction = (Target.position - self.position).normalized()

	if direction.x > 0:
		_animationPlayer.play("RatAttackRight")
	else:
		_animationPlayer.play("RatAttackLeft")

		
		
func PlayRunAnimationDirection(direction: Vector2):
	if direction.x > 0:
		_animationPlayer.play("RatWalkRight")
	elif direction.x < 0:
		_animationPlayer.play("RatWalkLeft")
	else:
		_animationPlayer.play("RatIdleRight")

func PlayLeapAnimationDirection(direction: Vector2):
	if direction.x > 0:
		_animationPlayer.play("RatLeapRight")
	elif direction.x < 0:
		_animationPlayer.play("RatLeapLeft")
	else:
		_animationPlayer.play("RatIdleRight")
func Attack():		
	print("attacking")
	self._current_state = State.ATTACKING
	
	#attacking - stops the attacks, the hitboxes are controlled through the animation player


		
func _random_direction() -> Vector2:
	var angle = rand_range(0, 2 * PI)
	return Vector2(cos(angle), sin(angle)).normalized()
	
	
	############ SIGNALS #################
	
	
onready var AttackNum := 0	
func _on_re_AttackTimer_timeout():
	if _current_state != State.ATTACKING:
		print("attack timer went off while not attacking")
		return
		
	#attacking , won't stop unless you exit the attacking range
	match _attack_state:
		AttackState.ATTACKING:
			pass
		AttackState.COOLING:
			if not (is_instance_valid(Target)):
				print("target not valid - cooling")
				self._current_state = State.APPROACHING
				return
					
			if Target.position.distance_to(position) > ATTACK_RANGE + 10: # extra buffer
				self._current_state = State.APPROACHING
				return
			
			Attack()
			AttackNum += 1
			if AttackNum > 3:
				AttackNum = 0
				_cooldownTimer.wait_time = _cooldownTimer.wait_time - 0.2
	

func _on_Vision_area_entered(area: Node) -> void: #if you dont have target, set a target
	match _current_state:
		State.PATROLLING:
			if _area_is_hostile(area):
				Target = area.get_parent()
				print("setting target")
				print(Target.position)
				print(Target)
				self._current_state = State.APPROACHING
			else:
				print("area is not player nor boid")
		
	
func _on_AttackRange_area_entered(area): #if entered the attack range attacks
	if not _area_is_hostile(area):
		return
	
	Target = area.get_parent()
	
	match _current_state:
		State.ATTACKING:
			pass
		_: 
			Attack()

func _area_is_hostile(area: Node) -> bool:
	return (area.get_parent().has_meta("Player") or area.get_parent().has_meta("Boid"))

func _on_AttackRange_area_exited(area):# if you exit, stops attacking and follows you
	if area.get_parent() != Target:
		return
	
	match _current_state:
		State.ATTACKING:
			match _attack_state:
				AttackState.ATTACKING:
					pass
				AttackState.COOLING:
					self._current_state = State.APPROACHING
			pass
		_: 
			print("target left attack range but was not in attack state")
			self._current_state = State.APPROACHING

	

	
func _on_patrolTimer_timeout() -> void:
	#change patrol direction every few seconds
	match _current_state:
		State.PATROLLING:
			Dir = _random_direction() # change direction
		_:
			print("patrol timer was running while not patrolling")
			_patrolTimer.stop()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "RatAttackLeft" or anim_name =="RatAttackRight":
		match _current_state:
			State.ATTACKING:
				# self._current_state = State.APPROACHING
				match _attack_state:
					AttackState.ATTACKING:
						print("COOL DOWN")
						self._attack_state = AttackState.COOLING
			_:
				print("attack timer finished while not in attack state")


func _on_AnimationPlayer_animation_started(anim_name):
	# self._current_state = State.ATTACKING ?
	pass


func _check_vision_and_set_target() -> bool:
	for area in $Vision.get_overlapping_areas():	
		if not _area_is_hostile(area): 
			continue
			
		Target = area.get_parent()
		return true
	
	Target = null
	return false
