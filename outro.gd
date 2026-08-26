extends Node2D

var kir_start_pos = Vector2.ZERO

func _ready() -> void:
	# Switch to custom camera
	$Player/Camera2D.enabled = false
	
	# kira starting pos
	kir_start_pos = $kira_pos.position
	$kira.bias = -1
	# Fade in
	$CanvasLayer/ColorRect.visible = true
	$kira/cake.visible = false
	var tween = create_tween()
	tween.tween_property($CanvasLayer/ColorRect, "color:a", 0, 1.0).set_trans(Tween.TRANS_CUBIC)
	# Starting Dialogue 
	tween.tween_callback(dialogue)

func dialogue():
	var dialogue_scene = load("res://UI/dialogue.tscn").instantiate()
	$CanvasLayer.add_child(dialogue_scene)
	$CanvasLayer/Dialogue.connect("dialog_finished",next_anim)
	$CanvasLayer/Dialogue.set_dialogue_text("res://UI/text_lines/outro.txt")
	

func next_anim() -> void:
	var tween = create_tween()
	# Kira go away from the camera and return with the cake 
	tween.tween_property($kira_pos, "position:x", 580, 1.0).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property($kira/cake, "visible", true, 0.0)
	tween.tween_property($kira_pos, "position:x", kir_start_pos.x, 4.0).set_trans(Tween.TRANS_CUBIC)
	# Cristiano comes with a present
	tween.parallel().tween_property($cris, "position:x", kir_start_pos.x + 22, 5.0).set_trans(Tween.TRANS_CUBIC).set_delay(0.7)
	# Final screen
	tween.tween_property($CanvasLayer/Label, "position:y", 128, 1.0).set_trans(Tween.TRANS_CUBIC)
	tween.parallel().tween_property($CanvasLayer/Button, "position:y", 328, 1.0).set_trans(Tween.TRANS_CUBIC)
	

func _on_button_pressed() -> void:
	get_tree().quit()
