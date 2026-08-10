extends Control

var new_game = preload("res://main.tscn").instantiate()

func _on_start_pressed() -> void:
	get_tree().root.add_child(new_game)
	get_tree().root.remove_child($".")
	queue_free()

func _on_quit_pressed() -> void:
	get_tree().quit()
