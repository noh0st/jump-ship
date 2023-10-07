extends Node2D

onready var _enemy_manager = get_node("/root/Main/EnemyManager")

var Target: Area2D
var TargetDir: Vector2
var HasTarget := false
onready var attackAnimationPlayer = $AnimationPlayer
onready var attackTimer = $AttackTimer
onready var _sprite = $Sprite

var health: int
export var healthMultiple : int = 5
func _ready():
	set_meta("Enemy", true)
	_sprite = "res://Assets/01.png"
	health = GlobalUpgradeStats.globalEnemyHealth * healthMultiple
	
func _process(delta):
	if Target != null:
		TargetDir = self.position - Target.position
		
		
func _on_TurtleVision_area_entered(area):
	if HasTarget == false:
		Target = area
		HasTarget = true
		
		attackTimer.start(0)
		print(TargetDir, area)
		

func _on_TurtleVision_area_exited(area):
	if area == Target:
		print("exit")
		if HasTarget == true:
			attackTimer.stop()
			Target = null
			HasTarget = false
			

func add_damage(value: int) -> void:
	print("turtle taking damage")
	health -= value
	
	if health <= 0:
		# enemy is dead
		_enemy_manager.remove_enemy(self)


func _on_AttackTimer_timeout():
	attackAnimationPlayer.play("RockTurtleAttack")


func _on_AnimationPlayer_animation_finished(anim_name):
	Target = null
	HasTarget = false


func _on_DamageZone_area_entered(area):
	print("entered turtle hit box")
	if area.get_parent().has_method("add_damage") and (not area.get_parent().has_meta("Enemy")):
		area.get_parent().add_damage(GlobalUpgradeStats.globalEnemyDamage)
	else:
		print("turtle cannot apply damage")
		print(area.get_parent())
