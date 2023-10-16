extends Node

signal on_game_win

var wave_count : int = 0

# wave manager has max threshold
# wave also has the current xp

onready var audio_stream_player = get_node("/root/Main/YSort/EnemyManager")



const Wave1: PackedScene = preload("res://Scenes/Wave1.tscn")
const Wave2: PackedScene = preload("res://Scenes/Wave2.tscn")
const Wave3: PackedScene = preload("res://Scenes/Wave3.tscn")
const WaveBoss: PackedScene = preload("res://Scenes/WaveBoss.tscn")

var _enemy_manager: Node

var _current_wave: Node
var _wave_index: int
var _upgrade_menu: Node
var _player: Node
var _ui: Node

var _xp: int

var _waves = [WaveBoss, Wave2, Wave3, WaveBoss]

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
	_wave_index = 0
	
	spawn_wave(_waves[_wave_index].instance())


func spawn_wave(wave: Node) -> void:
	
	self.add_child(wave)
	_current_wave = wave
	while _current_wave.get_node("Enemies").get_child_count() > 0:
		var enemy = _current_wave.get_node("Enemies").get_child(0)
		_current_wave.get_node("Enemies").remove_child(enemy)
		_enemy_manager.add_enemy(enemy)

	_ui.update_xp(_xp, _current_wave.xp_threshold)
	_play_music(_wave_index)

func _play_music(index: int) -> void:
	match index:
		0:
			$Wave1Music.play()
			$Wave2Music.stop()
			$BossMusic.stop()
		1:
			$Wave1Music.stop()
			$Wave2Music.play()
			$BossMusic.stop()
		3:
			$Wave1Music.stop()
			$Wave2Music.stop()
			$BossMusic.play()

func _on_Player_xp_update(value: int) -> void:
	if not is_instance_valid(_current_wave):
		return
		
	_xp += value
	
	_ui.update_xp(_xp, _current_wave.xp_threshold)
	
	if _xp >= _current_wave.xp_threshold:
		_upgrade_menu.UpgradesPOPUP(funcref(self, "_on_upgrade_selection"))


func _on_upgrade_selection() -> void:
	# show bar, spawn next wave
	if not is_instance_valid(_current_wave):
		return
	
	_xp = 0
	_current_wave.queue_free()
	
	_wave_index += 1
	spawn_wave(_waves[_wave_index].instance())
	
	
func game_win() -> void:
	if not is_instance_valid(_current_wave):
		return
	
	_current_wave.queue_free()
	# clean up enemies
	
	emit_signal("on_game_win")
