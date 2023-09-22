extends KinematicBody2D

signal health_update(new_value)

export var speed : float = 10.0
var health : int = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	self.set_meta("Player", true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var velocity : Vector2 = Input.get_vector("left", "right", "up", "down") * speed
	var collision : KinematicCollision2D = move_and_collide(velocity * delta, false)
	if  collision:
		if collision.collider.is_in_group("Enemies"):
			_handle_enemy_collision()


func _handle_enemy_collision() -> void:
	health -= 10
	emit_signal("health_update", health)

