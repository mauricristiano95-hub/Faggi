extends Node2D

var OFFSET = Vector2(30,-5)

var main_scene = preload("res://main.tscn").instantiate()

func _ready() -> void:
	
	# Disable player input and prepare black rect for fade-in-out
	$Player.set_process_input(false)
	$CanvasLayer/ColorRect.visible = true
	
	# Start Intro animations (fase in + kira movement)
	var tween = create_tween()
	tween.tween_property($CanvasLayer/ColorRect, "color:a", 0, 1.0).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($kira_pos, "position", $Player.position + OFFSET, 1.0).set_trans(Tween.TRANS_QUAD)

	tween.tween_callback(dialogue)

	
func dialogue():
	var dialogue_scene = load("res://UI/dialogue.tscn").instantiate()
	$CanvasLayer.add_child(dialogue_scene)
	$CanvasLayer/Dialogue.connect("dialog_finished",_on_dialogue_dialog_finished)


func scene_out():
	# Set Static Camera
	$Camera2D.position = $Player.position
	$Camera2D.zoom = $Player/Camera2D.zoom
	$Player/Camera2D.enabled = false
	
	# Move the player
	$kira.follow_player = true
	
func go_to_next_scene():
	get_tree().root.add_child(main_scene)
	get_tree().root.remove_child($".")
	queue_free()

func _on_dialogue_dialog_finished() -> void:
	var tween = create_tween()
	# Outro (kira + player go away off camera)
	tween.tween_callback(scene_out)
	tween.tween_property($Player, "input_override:x", 1, 1.0)
	tween.tween_property($CanvasLayer/ColorRect, "color:a", 1, 1.0).set_trans(Tween.TRANS_CUBIC)
	tween.tween_callback(go_to_next_scene)
