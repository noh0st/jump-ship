extends KinematicBody2D


signal _enemy_moused_over_true(enemy)
signal _enemy_moused_over_false(enemy)


enum State {
	IDLE,
	WALKING
}

export var walk_speed: float = 40.0

var _walk_direction: Vector2

onready var _health: int = 30
onready var _current_state: int = State.IDLE
onready var _timer: Timer = $Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	_timer.connect("timeout", self, "_on_timer_timeout")
	_timer.start(rand_range(2, 5))


func _process(delta: float) -> void:
	match _current_state:
		State.IDLE:
			pass
		State.WALKING:
			_process_walking(delta)
			
	
func _process_walking(delta: float):
	move_and_collide(_walk_direction * walk_speed * delta)
		

func _on_timer_timeout() -> void:
	match _current_state:
		State.IDLE:
			# choose direction and switch to walking
			_walk_direction = _random_normalized_direction()
			_current_state = State.WALKING
			_timer.start(rand_range(2, 5))
		State.WALKING:
			# stop walking
			_current_state = State.IDLE
			_timer.start(rand_range(2, 5))
			pass # do nothing


func _random_normalized_direction() -> Vector2:
	var angle = rand_range(0, 2 * PI)
	return Vector2(cos(angle), sin(angle)).normalized()
	
	
func _on_MouseDetectionTrigger_mouse_entered():
	emit_signal("_enemy_moused_over_true", self)


func _on_MouseDetectionTrigger_mouse_exited():
	emit_signal("_enemy_moused_over_false", self)


func _on_MouseDetectionTrigger_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			_apply_damage(10)
			
func _apply_damage(amount: int) -> void:
	_health -= amount
		
	# play hurt animation?
	
	if _health <= 0:
		# handle death
		queue_free()
