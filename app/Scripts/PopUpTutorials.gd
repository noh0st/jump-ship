extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Panel.visible = false
	$Panel2.visible = false

func _on_Button_pressed():
	$PressedSFX.play()
	$Panel.visible = false
	get_tree().paused = false

func _on_Button_mouse_entered():
	$HoveredSFX.play()
func StartTutorial():
	$Panel.visible = true
	get_tree().paused = true
func StartBossFight():
	$Panel2.visible = true
	get_tree().paused = true
func _on_BossButton_pressed():
	$PressedSFX.play()
	$Panel2.visible = false
	get_tree().paused = false

func _on_BossButton_mouse_entered():
	$HoveredSFX.play()
