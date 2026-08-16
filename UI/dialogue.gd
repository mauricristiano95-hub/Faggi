extends Control

@export var text_file_path = "res://UI/text_lines/intro.txt"

var text_lines = []
var i = 0

signal dialog_finished

func _ready() -> void:
	var text = FileAccess.open(text_file_path,FileAccess.READ)
	text_lines = text.get_as_text().split(" \n\n")
	$ColorRect/Label.text = text_lines[i]
	
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"): 
		if i < len(text_lines)-1:
			i+=1
			$ColorRect/Label.text = text_lines[i]
		else:
			emit_signal("dialog_finished")
			queue_free()
