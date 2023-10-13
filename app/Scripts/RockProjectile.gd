extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const DAMAGE = 30

var _direction: Vector2 = Vector2.ZERO
var _speed: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Spinning")
	pass # Replace with function body.
	
func init(direction: Vector2, speed: int):
	_direction = direction
	_speed = speed
	
	
func _physics_process(delta):
	move_and_slide(_direction * _speed)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _area_is_hostile(area: Node) -> bool:
	return (area.get_parent().has_meta("Player") or area.get_parent().has_meta("Boid"))


func _on_Hitbox_area_entered(area):
	if _area_is_hostile(area) and area.get_parent().has_method("add_damage"):
		area.get_parent().add_damage(DAMAGE)
		self.queue_free()


func _on_LifetimeTimer_timeout():
	self.queue_free()
