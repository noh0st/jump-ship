extends KinematicBody2D

onready var _enemy_manager = get_node("/root/Main/YSort/EnemyManager")

var Target : Node
var Dir := Vector2.ZERO

onready var _animationPlayer = $AnimationPlayer
onready var _cooldownTimer = $re_AttackTimer
onready var _patrolTimer = $patrolTimer

onready var _current_state: int = State.PATROLLING setget set_current_state

var xp_worth = 100
var boid_worth = 3
const SPEAR_DAMAGE = 50

var health: int = 0
export var healthMultiple : int = 25

enum State {
	PATROLLING,
	APPROACHING,
	ATTACKING,
	COOLING
}


func _ready():
	set_meta("Enemy", true)
	health = GlobalUpgradeStats.globalEnemyHealth * healthMultiple
	self._current_state = State.PATROLLING
	
	$HPbar.update_ui(health, health)
	
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
		_:
			move_and_slide(Vector2.ZERO)
			pass
			
	
func process_approaching(delta) -> void:
	if not (is_instance_valid(Target)):
		#print("target not valid - approaching")
		if not _check_vision_and_set_target():
			self._current_state = State.PATROLLING
		return
	
	if Target.position.distance_to(position) > VISION_RANGE: # out of vision range
		#print("target out of range")
		if not _check_vision_and_set_target():
			print("switching to patrolling")
			self._current_state = State.PATROLLING
			return

	if Target.position.distance_to(position) < ATTACK_RANGE: # within attack range
		#print("APPROACH IN RANGE")
		self._current_state = State.ATTACKING
		return
		
	
	var direction = (Target.position - position).normalized()
	Dir = direction
	var speed = 100
	PlayRunAnimationDirection(direction)
	move_and_collide(direction * speed * delta)
	
	
func set_current_state(value: int) -> void:
	match value:
		State.PATROLLING:
			if _current_state == value:
				return
			
			_current_state = value
			
			Dir = _random_direction()
			Target = null

			_patrolTimer.start() # timer to change directions
			_cooldownTimer.stop()
		State.APPROACHING:
			if _current_state == value:
				return
			
			_current_state = value
			
			_patrolTimer.stop()
			_cooldownTimer.stop()
		State.ATTACKING:					
			_current_state = value
			Dir = Vector2(0,0)
			_patrolTimer.stop()
			_cooldownTimer.stop()
			$AnimationPlayer.play("AttackAnticipation")
		State.COOLING:
			_patrolTimer.stop()
			_cooldownTimer.start(2)
			_current_state = value
			
	$DebugUI/Text.text = "state: %d" % [_current_state]
	
			
##########
func PlayAttackAnimation():
	#find direction of attack
	if not (is_instance_valid(Target)):
		return
		
	var direction = (Target.position - self.position).normalized()
	
	if direction.x > 0:
		_animationPlayer.play("AttackRight")

	else:
		_animationPlayer.play("AttackLeft")

		
		
func PlayRunAnimationDirection(direction: Vector2):
	if direction.x > 0:
		_animationPlayer.play("RunRight")
	elif direction.x < 0:
		_animationPlayer.play("RunLeft")
	else:
		_animationPlayer.play("Idle")


func Attack():		
	self._current_state = State.ATTACKING

func add_damage(value: int) -> void:
	health -= value
	
	$HPbar.update_ui(health, GlobalUpgradeStats.globalEnemyHealth * healthMultiple)
	
	print("spear guy hit for")
	print(value)
	
	if health <= 0:
		# enemy is dead
		_enemy_manager.remove_enemy(self)

		
func _random_direction() -> Vector2:
	var angle = rand_range(0, 2 * PI)
	return Vector2(cos(angle), sin(angle)).normalized()
	
	
	############ SIGNALS #################
	
	
onready var AttackNum := 0	
func _on_re_AttackTimer_timeout(): # cooldown timer
	#attacking , won't stop unless you exit the attacking range
	match _current_state:
		State.ATTACKING:
			pass	
			
		State.COOLING:
			if not (is_instance_valid(Target)):
				#print("target not valid - cooling")
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
		_:
			pass

func _on_Vision_area_entered(area: Node) -> void: #if you dont have target, set a target
	match _current_state:
		State.PATROLLING:
			if _area_is_hostile(area):
				Target = area.get_parent()
				print("spear target")
				print(Target)
				self._current_state = State.APPROACHING
			else:
				pass#	print("area is not player nor boid")

		
	
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


func _on_patrolTimer_timeout() -> void:
	#change patrol direction every few seconds
	match _current_state:
		State.PATROLLING:
			Dir = _random_direction() # change direction
		_:
			print("patrol timer was running while not patrolling")
			_patrolTimer.stop()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "AttackLeft" or anim_name =="AttackRight":
		match _current_state:
			State.ATTACKING:
				# self._current_state = State.APPROACHING
				print("COOL DOWN")
				self._current_state = State.COOLING
			_:
				print("attack timer finished while not in attack state")
	elif anim_name == "AttackAnticipation":
		# still attacking
		PlayAttackAnimation()
		

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


func _on_HitBox_area_entered(area):
	if area.get_parent().has_method("add_damage") and (not area.get_parent().has_meta("Enemy")):
		if is_instance_valid(self):
			area.get_parent().add_damage(SPEAR_DAMAGE, self)
		
		$AttackImpactSFX.play()
