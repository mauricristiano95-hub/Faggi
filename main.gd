extends Node2D

var endlevel_scene = preload("res://outro.tscn").instantiate()

@export var level_max_candles = 28
@export var level_max_health = 3

func level_complete():
	var tween = create_tween()
	$Player.DISABLED_INPUT = true
	tween.tween_callback($CanvasLayer/UI.set_level_complete)
	tween.tween_callback(go_to_next_scene).set_delay(1.0)

func go_to_next_scene():
	get_tree().root.add_child(endlevel_scene)
	get_tree().root.remove_child($".")
	queue_free()

func _ready() -> void:
	$Player.DISABLED_INPUT = true
	var tween = create_tween()
	tween.tween_callback($CanvasLayer/UI.set_level_start)
	PlayerStats.max_candles = level_max_candles
	PlayerStats.max_health = level_max_health
	PlayerStats.set_health(level_max_health)
	PlayerStats.set_candles(0)
	PlayerStats.connect("full_candles", level_complete)
	tween.tween_property($Player, "DISABLED_INPUT", false, 1.0)
