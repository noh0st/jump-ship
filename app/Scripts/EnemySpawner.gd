extends Node2D

onready var _player = get_node("../YSort/Player")
onready var _enemy_manager = get_node("/root/Main/EnemyManager")
onready var _timer: Timer = $Timer

const SPAWN_RADIUS = 250
const MAX_COUNT = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	_timer.connect("timeout", self, "_on_Timer_timeout")
	_timer.start(rand_range(3,7))


func _on_Timer_timeout():
	if _enemy_manager.size() < MAX_COUNT:
		# spawn enemy
		var enemy = _enemy_manager.spawn(_enemy_manager.Type.ENEMY)
		enemy.position = _player.position + _random_normalized_direction() * SPAWN_RADIUS
		enemy.position = _clamp_position(enemy.position, X_BOUNDS, Y_BOUNDS)

func _clamp_position(position: Vector2, xBounds: Vector2, yBounds: Vector2) -> Vector2:
	var x = clamp(position.x, xBounds.x, xBounds.y)
	var y = clamp(position.y, yBounds.x, yBounds.y)
	
	return Vector2(x, y)


func _random_normalized_direction() -> Vector2:
	var angle = rand_range(0, 2 * PI)
	return Vector2(cos(angle), sin(angle)).normalized()
	
	
