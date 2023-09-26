extends KinematicBody2D


signal _enemy_moused_over_true(enemy)
signal _enemy_moused_over_false(enemy)


enum State {
	IDLE,
	WALKING
}

export var walk_speed: float = 40.0
var TargetDir: Vector2
var _walk_direction: Vector2
onready var _leaptimer = $LeapTimer
onready var _health: int = 30
onready var _current_state: int = State.IDLE
onready var _timer: Timer = $Timer
onready var _targetlocktimer: Timer = $TargetLockTimer
var Target: Area2D 

# Called when the node enters the scene tree for the first time.

func _ready():
	_timer.connect("timeout", self, "_on_timer_timeout")
	_timer.start(rand_range(2, 5))
	set_meta("Enemy", false)

func _process(delta: float) -> void:
	match _current_state:
		State.IDLE:
			pass
		State.WALKING:
			_process_walking(delta)
	if Target != null:
		TargetDir =  Target.get_parent().position - self.position
func _process_walking(delta: float):
	move_and_collide(_walk_direction * walk_speed * delta)
		

func _on_timer_timeout() -> void:
	match _current_state:
		State.IDLE:
			#choose direction and switch to walking
			_walk_direction = _random_normalized_direction()
			_current_state = State.WALKING
			_timer.start(rand_range(2, 5))
			pass
		State.WALKING:
			# stop walking
			_current_state = State.IDLE
			#_timer.start(rand_range(2, 5))
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


######## Attacking

var HasTarget := false
func _on_VisionTrigger_area_entered(area):
	if HasTarget == true:
		if area != Target:
			print("not same target")
			if _targetlocktimer.time_left == 0:
				_leaptimer.stop()
				pass
			pass
		if area == Target && _targetlocktimer.time_left > 0:
			TargetSetter(area)
			_targetlocktimer.start(0)
			print("same target")
	if HasTarget == false:
		TargetSetter(area)
		print("new target")
func TargetSetter(targetArea):
	Target = targetArea
	HasTarget = true
	_walk_direction = Vector2.ZERO
	_current_state = State.IDLE
	_leaptimer.start(0)
	print(TargetDir, targetArea)
	
func Leap(LeapPower):
	move_and_slide(TargetDir.normalized() * LeapPower)
	
func _on_LeapTimer_timeout():
	
	Leap(3000)
	if Target != null:
		Leap(3000)
		
	



func _on_VisionTrigger_area_exited(area):
	print("exit")
	_targetlocktimer.start(0)


func _on_TargetLockTimer_timeout():
	print("target lost")
	_leaptimer.stop()
	Target = null
	HasTarget = false
	_current_state = State.WALKING
	_walk_direction = _random_normalized_direction()
