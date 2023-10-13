extends KinematicBody2D

enum State {
	ROAMING,
}

onready var _enemy_manager = get_node("/root/Main/YSort/EnemyManager")
onready var _animationPlayer = $AnimationPlayer
onready var _timer = $Timer
onready var _current_state: int = State.ROAMING setget set_current_state

var xp_worth = 1

var _health_ui: Node

var health: int = 0
export var healthMultiple : int = 100



func _ready():
	set_meta("Enemy", true)
	health = GlobalUpgradeStats.globalEnemyHealth * healthMultiple
	self._current_state = State.ROAMING
		
	_animationPlayer.play("RunRight")
	
	_timer.start(2)
	
const VISION_RANGE: int = 250
const ATTACK_RANGE: int = 50

var Target : Node
var _direction: Vector2 = Vector2.ZERO
var _speed: int

func _physics_process(delta): #Target death
	match _current_state:
		State.ROAMING:
			#PlayRunAnimationDirection(_direction)
			move_and_slide(_direction * _speed)
			
		
func init(health_ui: Node):
	_health_ui = health_ui
	health = 1000
	_health_ui.update_ui(health, health)
	
	
func set_current_state(value: int) -> void:
	pass
			
	# $DebugUI/Text.text = "state: %d \nattack_state %d" % [_current_state, _attack_state]
	
			
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



func add_damage(value: int) -> void:
	health -= value
	
	_health_ui.update_ui(health, GlobalUpgradeStats.globalEnemyHealth * healthMultiple)
	
	if health <= 0:
		# enemy is dead
		_enemy_manager.remove_enemy(self)

		
func _random_direction() -> Vector2:
	var angle = rand_range(0, 2 * PI)
	return Vector2(cos(angle), sin(angle)).normalized()
	
	
func _area_is_hostile(area: Node) -> bool:
	return (area.get_parent().has_meta("Player") or area.get_parent().has_meta("Boid"))



############ SIGNALS #################




func _on_Timer_timeout():
	match _current_state:
		State.ROAMING:
			# change direction and speed
			_direction = _random_direction();
			_speed = rand_range(0, 100)
			_timer.start(2)
	pass # Replace with function body.
