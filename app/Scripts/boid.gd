extends KinematicBody2D

onready var _boid_manager = get_node("/root/Main/BoidManager")

export var max_speed = 10.0

#the "weight" of each rule, how much force is applied in
#the direction of the rule
export var cohesion_force = 1.0
export var separation_force = 1.0
export var alignment_force = 1.0
export var follow_force = 30.0

var _angle = 0

export var follow_target = Vector2()
var player : Node2D
export var separation_threshold = 1.0

var flock: Node # set by BoidFlock

var velocity = Vector2()

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


func damage_boid(damage): # use this function when damaging the boid
	health -= damage
	health_calculation()
	
	
func health_calculation():
	HpBar.value = health
	
	if(health == MaxHealth):
		HpBar.visible = false
	elif(health != MaxHealth):
		HpBar.visible = true
		
	if health <= 0:
		health = 0
		emit_signal("BoidDied", self)
		BoidsGlobal.AllBoidsArray.remove(BoidsGlobal.AllBoidsArray.find(self))
		flock.remove(self)
	elif health >= MaxHealth:
		health = MaxHealth
		
		
######		
func _ready():
	BoidsGlobal.AllBoidsArray.append(self)
	HpBar.value = 100
	health = MaxHealth
	# these were breaking the game, because there are no enemies at the start of the game
	#get_parent().get_node("Enemy").connect("_enemy_moused_over_true", self, "_enemy_moused_over_true") 
	#get_parent().get_node("Enemy").connect("_enemy_moused_over_false", self, "_enemy_moused_over_false") 
	health_calculation()
	set_meta("Boid", true)

func _physics_process(delta):
	#this part is for the boids to maybe stay asleep till the player touches them
	# if(not self.get_meta("Boid")) : return
	
	if(Input.is_action_pressed("LeftClick")):
		follow_target = get_global_mouse_position()
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
		handle_single(delta) # float around owner 
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
	move_and_slide(velocity)

func handle_single(delta: float) -> void:
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
				steer_away -= (b.global_position - global_position).normalized() * (d/separation_threshold*10)
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


func _on_HurtBox_area_entered(area):
	
	damage_boid(50)
