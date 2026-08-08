extends Node2D

@export var FLUCT_SPEED = 8
@export var FLUCT_AMPLITUDE = 3
var rot = 0
var candle_taken = false
@onready var start_pos = $".".position


func _physics_process(delta: float) -> void:
	# Candle Fluctuating Movement
	if candle_taken == false:
		rot += delta*FLUCT_SPEED*0.1
		position.y = start_pos.y + sin(2*PI*rot)*FLUCT_AMPLITUDE
		if rot > 1: rot = 0


func _on_area_2d_body_entered(body: Node2D) -> void:
	$AnimationPlayer.play("candle_take")
	candle_taken = true


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == 'candle_take':
		queue_free()
