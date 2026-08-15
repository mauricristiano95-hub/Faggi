extends Node2D

var OFFSET = Vector2(30,-5)

func _ready() -> void:
	
	# Disable player input and prepare black rect for fade-in-out
	$Player.set_process_input(false)
	$CanvasLayer/ColorRect.visible = true
	$CanvasLayer/DialoguePanel.visible = false
	
	# Start Intro animations (fase in + kira movement)
	var tween = create_tween()
	tween.tween_property($CanvasLayer/ColorRect, "color:a", 0, 1.0).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($kira_pos, "position", $Player.position + OFFSET, 1.0).set_trans(Tween.TRANS_QUAD)

	tween.tween_callback(dialogue)

	# Outro (kira + player go away off camera)
	tween.tween_callback(scene_out).set_delay(2)
	tween.tween_property($Player, "input_override:x", 1, 1.0)
	tween.tween_property($CanvasLayer/ColorRect, "color:a", 1, 1.0).set_trans(Tween.TRANS_CUBIC)
	
func dialogue():
	$CanvasLayer/DialoguePanel.visible = true


func scene_out():
	$CanvasLayer/DialoguePanel.visible = false

	# Set Static Camera
	$Camera2D.position = $Player.position
	$Camera2D.zoom = $Player/Camera2D.zoom
	$Player/Camera2D.enabled = false
	# Move the player
	$kira.follow_player = true
