extends KinematicBody2D

export var max_speed = 10.0

#the "weight" of each rule, how much force is applied in
#the direction of the rule
export var cohesion_force = 1.0
export var separation_force = 1.0
export var alignment_force = 1.0
export var follow_force = 1.0

export var follow_target = Vector2()
var player : Node2D
export var separation_threshold = 1.0

var velocity = Vector2()

#each boid needs to keep an array of each other boid in the scene. 
#might be optimized by outsourcing the logic for moving the boids to another
#script that keeps track of all the boids and sends them their position each frame
var boids = []

func _ready():

	self.set_meta("Boid", false)

func _process(delta):
	#find all boids in the normal process to keep accurate track of them, all
	#other calculations will be done in physics process to keep them framerate independent
	boids = find_all_boids()

func _physics_process(delta):
	#this part is for the boids to maybe stay asleep till the player touches them
	if(not self.get_meta("Boid")) : return
	
	if(Input.is_action_pressed("LeftClick")):
		follow_target = get_global_mouse_position()
	else:
		follow_target = player.position
	#finds the final direction vector by summing all the rules and their weights, then moves the boid using godots physics system
	var movement_vector
	if(len(boids) > 1):
		movement_vector = cohesion() * cohesion_force + separation() * separation_force + alignment() * alignment_force + follow(follow_target) * follow_force
	else:
		movement_vector = follow(follow_target) * follow_force
	velocity += movement_vector
	velocity = clamp_vector(velocity, -max_speed , max_speed)
	move_and_slide(velocity)


func find_all_boids():
	var boids = []
	#each boid prefab is tagged as a "Boid" with metadata
	for c in self.get_parent().get_children():
		if(c.has_meta("Boid")):
			if(c.get_meta("Boid")):
				boids.append(c)

	return boids
	
#finds the "percieved center of mass" of the boid, returns the 
#direction to that center of mass
func cohesion():
	var percieved_center = Vector2(0,0)
	for b in boids:
		if(b!=self):
			percieved_center += b.position
			
	percieved_center /= (len(boids)-1)
	var result = global_position.direction_to(percieved_center)
	
	return result
	
#makes the boids steer away from any other boids 
func separation():
	var steer_away = Vector2(0,0)
	for b in boids:
		if(b!=self):
			var d = global_position.distance_to(b.global_position)
			if(d>0 and d < separation_threshold):
				steer_away -= (b.global_position - global_position).normalized() * (d/separation_threshold*10)
	return steer_away

#makes the boids try to go in the same direction as all the other boids. I've noticed you need to plug in very low values for this not to break, not sure why.
func alignment():
	var percieved_velocity = Vector2(0,0)
	for b in boids:
		if(b!=self):
			percieved_velocity += b.velocity
	percieved_velocity /= (len(boids) - 1)
	return percieved_velocity
	
#follow a Node2D target
func follow(target : Vector2):
	return global_position.direction_to(target)
	
#wall avoidance idea: detect collision with trigger area, 
#if wall is detected, add force in the normal direction


func _on_area_body_entered(body):
	if(body.has_meta("Player")):
		player = body
		follow_target = player.position
		if(not self.get_meta("Boid")):
			self.set_meta("Boid", true)
			
func clamp_vector(value : Vector2, minVal : float, maxVal : float):
	var x = clamp(value.x, minVal, maxVal)
	var y = clamp(value.y, minVal, maxVal)
	var newVector = Vector2(x, y)
	return newVector
