extends KinematicBody2D


var Target : Node
var Dir := Vector2.ZERO
onready var _enemy_manager = get_node("/root/Main/YSort/EnemyManager")
var health: int = 0
export var healthMultiple : int = 3

onready var _animationPlayer = $AnimationPlayer
onready var _cooldownTimer = $re_AttackTimer
onready var _patrolTimer = $patrolTimer

onready var _current_state: int = State.PATROLLING setget set_current_state

var xp_worth = 120

enum State {
	PATROLLING,
	LEAPING, # leap is a fixed distance
	ATTACKING,
	COOLING
}


func _ready():
	set_meta("Enemy", false)
	health = GlobalUpgradeStats.globalEnemyHealth * healthMultiple
	self._current_state = State.PATROLLING
	$HPbar.update_ui(health, health)
	_animationPlayer.play("Idle")
	
	
const ATTACK_RANGE: int = 50

	
func _physics_process(delta): #Target death
	match _current_state:
		State.PATROLLING:
			var speed = 100
			PlayRunAnimationDirection(Dir)
			move_and_slide(Dir * speed)
		State.LEAPING:
			if not (is_instance_valid(Target)):
				print(Target)
				print("target not valid - approaching")
				if not _check_vision_and_set_target():
					self._current_state = State.PATROLLING
				return
			
			# leap animation is playing
			# move player
			var direction = (Target.position - position).normalized()
			Dir = direction
	
			if Target.position.distance_to(position) < ATTACK_RANGE:
				print("APPROACH IN RANGE")
				Attack()
				return
	
			var leap_speed = 300
			PlayLeapAnimationDirection(direction)
			move_and_slide(leap_speed * direction)
		State.ATTACKING:
			# attack animation is playing
			pass
			#process_attacking(delta)
		State.COOLING:
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
		State.LEAPING:
			if _current_state == value:
				return
			
			_current_state = value
			
			_cooldownTimer.start(rand_range(0.3, 0.6))
			_patrolTimer.stop()
		State.ATTACKING:					
			_current_state = value
			PlayAttackAnimation()
			Dir = Vector2(0,0)
			_cooldownTimer.start(1.5)
			_patrolTimer.stop()
		State.COOLING:
			_current_state = value
			_cooldownTimer.start(3)
			
	$DebugUI/Text.text = "state: %d" % [_current_state]
	

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
	#attacking , won't stop unless you exit the attacking range
	match _current_state:
		State.ATTACKING:
			pass
		State.LEAPING:
			Attack()
		State.COOLING:
			if not (is_instance_valid(Target)):
				print("target not valid - cooling")
				if not _check_vision_and_set_target():
					self._current_state = State.PATROLLING
				else:
					self._current_state = State.LEAPING
				return
					
			if Target.position.distance_to(position) > ATTACK_RANGE + 10: # extra buffer
				self._current_state = State.LEAPING
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
				self._current_state = State.LEAPING
			else:
				print("area is not player nor boid")
		

func _area_is_hostile(area: Node) -> bool:
	return (area.get_parent().has_meta("Player") or area.get_parent().has_meta("Boid"))
	
	
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
				print("ATTACK animation donw, going to cooling")
				self._current_state = State.COOLING
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


func _on_Area2D_area_entered(area): # hitbox
	if not _area_is_hostile(area):
		return
		
	if area.get_parent().has_method("add_damage") and (not area.get_parent().has_meta("Enemy")):
		area.get_parent().add_damage(GlobalUpgradeStats.globalEnemyDamage, self)
		

func add_damage(value: int) -> void:
	health -= value
	
	$HPbar.update_ui(health, GlobalUpgradeStats.globalEnemyHealth * healthMultiple)
	
	print("rat hit for")
	print(value)
	
	if health <= 0:
		# enemy is dead
		_enemy_manager.remove_enemy(self)
	
