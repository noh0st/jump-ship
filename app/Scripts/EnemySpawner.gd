extends Node2D

onready var _player = get_node("../YSort/Player")
onready var _enemy_manager = get_node("/root/Main/EnemyManager")
onready var _timer: Timer = $Timer

const SPAWN_RADIUS = 250
const MAX_COUNT = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	_timer.connect("timeout", self, "_on_Timer_timeout")
	_timer.start(rand_range(3,7))


func _on_Timer_timeout():
	if _enemy_manager.size() < MAX_COUNT:
		# spawn enemy
		var enemy = _enemy_manager.spawn_enemy()
		enemy.position = _player.position + _random_normalized_direction() * SPAWN_RADIUS


func _random_normalized_direction() -> Vector2:
	var angle = rand_range(0, 2 * PI)
	return Vector2(cos(angle), sin(angle)).normalized()
	
	
