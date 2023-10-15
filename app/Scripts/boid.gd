extends KinematicBody2D

export var max_speed = 10.0


enum State {
	BOIDING,
	GUIDING,
	CIRCLING,
	LUNGING,
	RETREATING
}


onready var _enemy_manager = get_node("/root/Main/YSort/EnemyManager")
#the "weight" of each rule, how much force is applied in
#the direction of the rule
export var cohesion_force = 1.0
export var separation_force = 1.0
export var alignment_force = 1.0
export var follow_force = 30.0

var _angle = 0

var _boid_speed: float = 1.0

var attack_target: Node
var player : Node2D
export var separation_threshold = 1.0

onready var _current_state: int = State.BOIDING setget set_current_state

var flock: Node # set by BoidFlock

var velocity = Vector2()

onready var _animation_player = $AnimationPlayer

#var enemy_target : bool = false
#var enemy_to_target : Node2D
#each boid needs to keep an array of each other boid in the scene. 
#might be optimized by outsourcing the logic for moving the boids to another
#script that keeps track of all the boids and sends them their position each frame

######
#Health Related Code
onready var HpBar = $HPbar
var health: float
var MaxHealth := 100

var _last_position : Vector2

func health_calculation():
	HpBar.update_ui(health, MaxHealth)
	HpBar.visible = true
	if health <= 0:
		health = 0
		
		BoidsGlobal.AllBoidsArray.remove(BoidsGlobal.AllBoidsArray.find(self))
		flock.remove(self)
	elif health >= MaxHealth:
		health = MaxHealth
		HpBar.visible = false
		
		
func HealAndChangeMaxHealth():
	MaxHealth = GlobalUpgradeStats.globalSelfHealth
	health = GlobalUpgradeStats.globalSelfHealth
	HpBar.update_ui(GlobalUpgradeStats.globalSelfHealth, GlobalUpgradeStats.globalSelfHealth)
	
	
func _ready():
	$Heal.visible = false
	GlobalUpgradeStats.connect("MaxHealthChanged", self, "HealAndChangeMaxHealth")
	$Sprite.modulate = Color( 1, 1, 1, 1 )
	BoidsGlobal.AllBoidsArray.append(self)
	HpBar.value = 100
	health = MaxHealth
	
	self.set_meta("Boid", true)
	# these were breaking the game, because there are no enemies at the start of the game
	#get_parent().get_node("Enemy").connect("_enemy_moused_over_true", self, "_enemy_moused_over_true") 
	#get_parent().get_node("Enemy").connect("_enemy_moused_over_false", self, "_enemy_moused_over_false") 
	health_calculation()
	
	_boid_speed = rand_range(0.5, 1.7)
	print(_boid_speed)


func set_current_state(value) -> void:
	_current_state = value
	
	match value:
		State.GUIDING:					
			$CooldownTimer.start(2)
		State.CIRCLING:
			$CooldownTimer.start(0.4)
		_:
			pass
			
	$DebugUI/Label.text = "state: %d" % [_current_state]

func _physics_process(delta) -> void:
	match _current_state:
		State.BOIDING:
			process_boiding(delta)
		State.RETREATING:
			process_retreating(delta)
		State.GUIDING:
			process_boiding(delta)
		State.CIRCLING:
			process_circling(delta)
		State.LUNGING:
			process_lunging(delta)
			
	PlayRunAnimationDirection(position - _last_position)
	_last_position = position
			

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT  and event.pressed: # interrupt whatever boid is doing
		print("mouse boid")
		self._current_state = State.GUIDING
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT  and not event.pressed: # interrupt whatever boid is doing
		if _current_state == State.GUIDING:
			if _check_vision_and_set_target():
				print("GUIDING TO LUNGING")
				self._current_state = State.LUNGING
			else:
				print("GUIDING TO HOIDING")
				self._current_state = State.BOIDING
	

func PlayRunAnimationDirection(direction: Vector2):
	if direction.x > 0:
		_animation_player.play("WalkRight")
	else:
		_animation_player.play("WalkLeft")
	
	
func process_lunging(delta) -> void:
	if not (is_instance_valid(attack_target)):
		# print("attack target not valid")
		self._current_state = State.BOIDING
		return
		
	if attack_target.position.distance_to(position) >= 200.0: 
		self._current_state = State.BOIDING
		return
		
	if attack_target.position.distance_to(position) <= 15: 
		self._current_state = State.RETREATING
		return
		
	# lung forward until hit lands
	var direction = (attack_target.position - position).normalized()
	var speed = 250.0
	move_and_slide(direction * speed)
		
		
func process_retreating(delta) -> void: # move away from target 
	if not (is_instance_valid(attack_target)):
		# print("attack target not valid")
		self._current_state = State.BOIDING
		return
		
	if attack_target.position.distance_to(position) >= 200.0: 
		self._current_state = State.BOIDING
		return
		
	
	if attack_target.position.distance_to(position) >= 130.0: 
		self._current_state = State.CIRCLING
		return
		
	var direction = (attack_target.position - position).normalized()
	var speed = -250.0 # move away
	
	move_and_slide(direction * speed)
	
	
func process_circling(delta) -> void: # lunge cooldown
	if not (is_instance_valid(attack_target)):
	# print("attack target not valid")
		self._current_state = State.BOIDING
		return
		
	if attack_target.position.distance_to(position) >= 300.0: 
		self._current_state = State.BOIDING
		return
		
	process_circling_boid(delta)


func clamp_guidance_target(target: Vector2, dist: int) -> Vector2:
	var diff = target - flock.owner_position() #).normalized()
	var target_dist = diff.length()
	var dir = diff.normalized()
	
	var new_dist = min(target_dist, dist)
	
	return (new_dist * dir) + flock.owner_position()
	

func process_circling_boid(delta) -> void:
	var boids: Array = flock.boids()
	
	if not (is_instance_valid(attack_target)):
		# print("attack target not valid")
		self._current_state = State.BOIDING
		return
	
	if boids.size() == 0:
		print("boids empty")
		return 
	
	if boids.size() == 1:
		print("boids single")
		handle_single(delta, attack_target.position) # float around owner 
		return
	
	var	movement_vector = (
		cohesion(boids) * cohesion_force 
		+ separation(boids) * separation_force * 3
		+ alignment(boids) * alignment_force 
		+ follow(attack_target.position) * follow_force
	)
	
	#else:
	#	movement_vector = follow(follow_target) * follow_force
	
	velocity += movement_vector 
	velocity = clamp_vector(velocity, -max_speed, max_speed)
	move_and_slide(velocity * _boid_speed / 2)


func process_boiding(delta) -> void:
		#this part is for the boids to maybe stay asleep till the player touches them
	# if(not self.get_meta("Boid")) : return
	
	var follow_target: Vector2
	
	if(Input.is_action_pressed("LeftClick")):
		follow_target = clamp_guidance_target(get_global_mouse_position(), 300)
	else:
		follow_target = flock.owner_position()

		
	#finds the final direction vector by summing all the rules and their weights, then moves the boid using godots physics system
	#var movement_vector
	#if(len(boids) > 1):

	var boids: Array = flock.boids()
	
	if boids.size() == 0:
		print("boids empty")
		return 
	
	if boids.size() == 1:
		print("boids single")
		handle_single(delta, follow_target) # float around owner 
		return
	
	var	movement_vector = (
		cohesion(boids) * cohesion_force 
		+ separation(boids) * separation_force 
		+ alignment(boids) * alignment_force 
		+ follow(follow_target) * follow_force
	)
	
	#else:
	#	movement_vector = follow(follow_target) * follow_force
	
	velocity += movement_vector 
	velocity = clamp_vector(velocity, -max_speed , max_speed)
	move_and_slide(velocity * _boid_speed)


func handle_single(delta: float, follow_target: Vector2) -> void:
	_angle += 2 * delta
	var radius = 30
	var target_position = follow_target
	var new_position = Vector2(
		target_position.x + radius * cos(_angle),
		target_position.y + radius * sin(_angle)
	)
	position = lerp(position, new_position, 0.1)
	
	
	
#finds the "percieved center of mass" of the boid, returns the 
#direction to that center of mass
func cohesion(boids: Array) -> Vector2:
	var percieved_center = Vector2(0,0)
	for b in boids:
		if(b!=self && boids.has(self) ):
			percieved_center += b.position
			
			
	percieved_center /= (len(boids)-1)
	var result = global_position.direction_to(percieved_center)
	
	return result
	
	
#makes the boids steer away from any other boids 
func separation(boids: Array) -> Vector2:
	var steer_away = Vector2(0,0)
	for b in boids:
		if(b!=self && boids.has(self) ):
			var d = global_position.distance_to(b.global_position)
			if(d>0 and d < separation_threshold):
				steer_away -= (b.global_position - global_position).normalized() * (d/separation_threshold*15)
	return steer_away


#makes the boids try to go in the same direction as all the other boids. I've noticed you need to plug in very low values for this not to break, not sure why.
func alignment(boids: Array) -> Vector2:
	var percieved_velocity = Vector2(0,0)
	for b in boids:
		if(b!=self && boids.has(self) ):
			percieved_velocity += b.velocity
	percieved_velocity /= (len(boids) - 1)
	return percieved_velocity
	
	
#follow a Node2D target
func follow(target : Vector2) -> Vector2:
	return global_position.direction_to(target)
	
#wall avoidance idea: detect collision with trigger area, 
#if wall is detected, add force in the normal direction

			
func clamp_vector(value : Vector2, minVal : float, maxVal : float):
	var x = clamp(value.x, minVal, maxVal)
	var y = clamp(value.y, minVal, maxVal)
	var newVector = Vector2(x, y)
	return newVector

	
func _on_AwakenBoidTrigger_area_entered(area):
	pass
	#if area.is_in_group("Hitbox") and area.get_parent().has_meta("Enemy"):
	#	damage_boid(50)

func add_damage(value: int, knockback_dealer: Node) -> void:
	health -= value
	health_calculation()


	if is_instance_valid(knockback_dealer):
		move_and_slide(Vector2(PlayerStats.globalSelfKnockBack * (self.position.x - knockback_dealer.position.x), PlayerStats.globalSelfKnockBack * (self.position.y - knockback_dealer.position.y)))
	$TakeDamageSFX.play()
	
	
func _on_EnemyDetectionTrigger_area_entered(area):
	if area.get_parent().has_meta("Enemy"):
		#print("enemy detection")
		#print(area.get_parent())
		match _current_state:
			State.BOIDING:
				print("setting vision entered attacking")
				attack_target = area.get_parent()
				self._current_state = State.LUNGING
			_:
				pass # print("unhandled vision entered")
	else: 
		pass #"vision not enemy"
		

func _on_Hitbox_area_entered(area) -> void:
	if area.get_parent().has_meta("Enemy"):
		match _current_state:
			State.LUNGING:
				_on_hitbox_attacking(area)
			_:
				pass #
		
		
func _on_hitbox_attacking(area) -> void:
	# APPLY DAMAGAGE
	if area.get_parent() == flock.flock_owner:
		return
	
	if area.get_parent().has_method("add_damage"):
		$AttackSFX.play()
		area.get_parent().add_damage(GlobalUpgradeStats.boidDamage)
		
		self._current_state = State.RETREATING


func add_health(value):
	health += value
	health_calculation()
	if health != MaxHealth:
		
		$Heal.visible = true
		$Heal.text = "+" + str(value)
		$UITimer.start()


func _on_UITimer_timeout():
	$Heal.visible = false # Replace with function body.


func _on_CooldownTimer_timeout():
	match _current_state:
		State.CIRCLING:
			self._current_state = State.LUNGING
		State.GUIDING:
			if _check_vision_and_set_target():
				print("GUIDING TO LUNGING")
				self._current_state = State.LUNGING
			else:
				print("GUIDING TO HOIDING")
				self._current_state = State.BOIDING
		_:
			pass


func _check_vision_and_set_target() -> bool:
	for area in $EnemyDetectionTrigger.get_overlapping_areas():	
		if not area.get_parent().has_meta("Enemy"):
			continue
			
		attack_target = area.get_parent()
		return true
	
	attack_target = null
	return false
