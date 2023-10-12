extends Node

var wave_count : int = 0

# wave manager has max threshold
# wave also has the current xp


const Wave1: PackedScene = preload("res://Scenes/Wave1.tscn")

var _enemy_manager: Node

var current_wave: Node
var _upgrade_menu: Node
var _player: Node
var _ui: Node

var _xp: int

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	 pass # Replace with function body.
	
	
func init(player: Node, upgrades: Node, enemy_manager: Node, ui: Node):
	_upgrade_menu = upgrades
	_enemy_manager = enemy_manager
	_player = player
	_ui = ui
	
	_xp = 0
	
	spawn_wave(Wave1.instance())

func spawn_wave(wave: Node) -> void:
	self.add_child(wave)
	current_wave = wave
	print("spawning wave one")
	
	for child_index in current_wave.get_node("Enemies").get_child_count():
		var child_node = current_wave.get_node("Enemies").get_child(child_index)
		
		_enemy_manager.add_enemy(child_node)

	_ui.update_xp(_xp, current_wave.xp_threshold)


func _on_Player_xp_update(value: int) -> void:
	_xp += value
	
	_ui.update_xp(_xp, current_wave.xp_threshold)
	
	if _xp >= current_wave.xp_threshold:
		_upgrade_menu.UpgradesPOPUP(funcref(self, "_on_upgrade_selection"))


func _on_upgrade_selection() -> void:
	# show bar, spawn next wave
	_xp = 0
	var nextWave = current_wave.NextWave
	current_wave.queue_free()
	spawn_wave(nextWave.instance())
