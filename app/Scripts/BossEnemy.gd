extends KinematicBody2D

signal on_dead

const RockProjectile: PackedScene = preload("res://Scenes/RockProjectile.tscn")

enum State {
	ROAMING,
	ROCK_THROW
}

onready var _enemy_manager = get_node("/root/Main/YSort/EnemyManager")
onready var _animationPlayer = $AnimationPlayer
onready var _timer = $Timer
onready var _attackTimer = $AttackTimer
onready var _current_state: int = State.ROAMING setget set_current_state

var xp_worth = 1

var _health_ui: Node
var _player: Node

var health: int = 0
export var healthMultiple : int = 30

func _ready():
	set_meta("Enemy", true)
	
	self._current_state = State.ROAMING
		
	_animationPlayer.play("RunRight")
	
	_timer.start(2)
	_attackTimer.start(4)
	
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
		State.ROCK_THROW:
			return
			
		
func init(health_ui: Node, player: Node):
	_health_ui = health_ui
	
	health = GlobalUpgradeStats.globalEnemyHealth * healthMultiple
	_health_ui.update_ui(health, health)
	
	_player = player
	
	
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
	
	print("boss taking damage")
	print(health)
	
	_health_ui.update_ui(health, GlobalUpgradeStats.globalEnemyHealth * healthMultiple)
	
	if health <= 0:
		# enemy is dead
		_enemy_manager.remove_enemy(self)
		emit_signal("on_dead")

		
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
			
	pass # Replace with function body.


func _on_AttackTimer_timeout():
	match _current_state:
		State.ROAMING:
			# change direction and speed
			_direction = Vector2.ZERO
			_speed = 0
			
			#_current_state = State.ROCK_THROW
			
			$AnimationPlayer.play("RockThrow")
			



func _on_AnimationPlayer_animation_finished(anim_name):
	match anim_name:
		"RockThrow":
			fire_rock_projectile()
			$AttackTimer.start(rand_range(0.5, 3))


func fire_rock_projectile() -> void:
	var rock = RockProjectile.instance()
	rock.position = position
	rock.init((_player.position - position).normalized(), rand_range(200, 450))	
	_enemy_manager.add_child(rock)
	
