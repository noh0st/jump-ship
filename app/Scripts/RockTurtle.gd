extends Node2D

onready var _enemy_manager = get_node("/root/Main/YSort/EnemyManager")

var Target: Area2D
var HasTarget := false
onready var attackAnimationPlayer = $AnimationPlayer
onready var attackTimer = $AttackTimer
onready var _sprite = $Sprite

var health: int
export var healthMultiple : int = 4

var xp_worth: int = 20
var boid_worth = 1
const DAMAGE = 34

func _ready():
	$Sprite.modulate = Color(0.6, 0.7, 0.9) # blue shade
	scale.x = 1 if randi() % 2 == 0 else -1
	
	set_meta("Enemy", true)
	_sprite = "res://Assets/01.png"
	health = GlobalUpgradeStats.globalEnemyHealth * healthMultiple
	$HPbar.update_ui(health, health)
		
		
func _on_TurtleVision_area_entered(area):
	if area.get_parent() == self:
		return
	
	Target = area
	HasTarget = true

	if not attackAnimationPlayer.is_playing():
		attackAnimationPlayer.play(("AttackAnticipation"))

		

func _on_TurtleVision_area_exited(area):
	if area.get_parent() == self:
		return
	
	if area == Target:
		#print("exit")
		if HasTarget == true:
			attackTimer.stop()
			Target = null
			HasTarget = false
			

func add_damage(value: int) -> void:
	health -= value
	
	$HPbar.update_ui(health, GlobalUpgradeStats.globalEnemyHealth * healthMultiple)
	
	if health <= 0:
		_enemy_manager.remove_enemy(self)


func _on_AttackTimer_timeout() -> void:
	print("attack timer timeout")
	attackAnimationPlayer.play("RockTurtleAttack")
	if not _check_vision():
		HasTarget = false
		Target = null
		attackTimer.stop()
	


func _check_vision() -> bool:
	for area in $TurtleVision.get_overlapping_areas():	
		if 	area.get_parent().has_meta("Player") or area.get_parent().has_meta("Boid"):
			return true
	
	return false


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "AttackAnticipation":
		attackAnimationPlayer.play("RockTurtleAttack")
		attackTimer.start(1)


func _on_DamageZone_area_entered(area):
	if area.get_parent() == self: 
		return
	
	if area.get_parent().has_method("add_damage") and (not area.get_parent().has_meta("Enemy")):
		if is_instance_valid(self):
			area.get_parent().add_damage(DAMAGE, self)
