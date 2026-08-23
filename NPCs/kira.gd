extends CharacterBody2D


@export var SPEED = 450
@export var HORIZONTAL_FLOAT_AMPLITUDE = 1
@export var VERTICAL_FLOAT_AMPLITUDE = 5
@export var HORIZONTAL_OFFSET = 20
@export var VERTICAL_OFFSET = 0
@export var follow_player = true # it needs a 2D node called "kira_pos" to move properly for custom movement

var OFFSET = Vector2.ZERO
var rot = 0 # don't touch this!
var bias = 1 # don't touch this!
var pos_player = Vector2.ZERO
var vel_player = Vector2.ZERO

func _physics_process(delta: float) -> void:

	# Kira fluctuation and movement	
	if follow_player:
		pos_player = get_parent().find_child('Player').get('position')
		vel_player = get_parent().find_child('Player').get('velocity')
		if vel_player.x != 0:
			bias = sign(vel_player.x)
	else:
		if get_parent().find_child('kira_pos') != null:
			pos_player = get_parent().find_child('kira_pos').get('position')
		bias=0

	rot += 1
	OFFSET.x = sin(2*PI*rot*0.01)*HORIZONTAL_FLOAT_AMPLITUDE + HORIZONTAL_OFFSET*bias
	OFFSET.y = cos(2*PI*rot*0.01)*VERTICAL_FLOAT_AMPLITUDE + VERTICAL_OFFSET
	if rot > 100: rot = 0

	var kira_mov = (position - pos_player + OFFSET)*SPEED
	velocity = -kira_mov*delta
	move_and_slide()
	
	# Kira Sprite direction
	if bias <= 0:
		$Sprite2D.flip_h = true 
	else: 
		$Sprite2D.flip_h = false
