extends Control

@export var text_file_path = "res://UI/text_lines/intro.txt"
@export var TYPING_SPEED = 100

var text_lines = []
var i = 0

signal dialog_finished

func _ready() -> void:
	set_dialogue_text(text_file_path)

func set_dialogue_text(dialog_text_file_path):
	var text = FileAccess.open(dialog_text_file_path,FileAccess.READ)
	text_lines = text.get_as_text().split("\n\n")
	$ColorRect/Label.visible_characters = 0
	$ColorRect/Label.text = text_lines[i]
	
func _process(delta: float) -> void:
	
	# Characters Typing effect
	if $ColorRect/Label.visible_characters < len($ColorRect/Label.text):
		$ColorRect/Label.visible_characters += delta*TYPING_SPEED
		$ColorRect/Node2D/Sprite2D.visible = false
	else:
		$ColorRect/Node2D/Sprite2D.visible = true
	
	# Dialogue paging
	if Input.is_action_just_pressed("JUMP") and $ColorRect/Label.visible_ratio == 1.0: 
		if i < len(text_lines)-1:
			i+=1
			$ColorRect/Label.text = text_lines[i]
			$ColorRect/Label.visible_characters = 0
		else:
			emit_signal("dialog_finished")
			queue_free()
