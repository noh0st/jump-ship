extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	get_tree().paused = false
func _on_Button_pressed():
	$PressedSFX.play()
	visible = false
	get_tree().paused = false

func _on_Button_mouse_entered():
	$HoveredSFX.play()
func StartTutorial():
	visible = true
	$Panel2.visible = false
	$Panel.visible = true
	get_tree().paused = true
func StartBossFight():
	visible = true
	$Panel.visible = false
	$Panel2.visible = true
	get_tree().paused = true
func _on_BossButton_pressed():
	$PressedSFX.play()
	visible = false
	get_tree().paused = false

func _on_BossButton_mouse_entered():
	$HoveredSFX.play()
