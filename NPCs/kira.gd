extends CharacterBody2D


@export var SPEED = 500
@export var HORIZONTAL_FLOAT_AMPLITUDE = 1
@export var VERTICAL_FLOAT_AMPLITUDE = 5
@export var HORIZONTAL_OFFSET = 12
@export var VERTICAL_OFFSET = 0

var OFFSET = Vector2.ZERO
var rot = 0 # don't touch this!
var bias = 1 # don't touch this!

func _physics_process(delta: float) -> void:
	
	#velocity.y += delta*98.0
	
	var pos_player = get_parent().find_child('Player').get('position')
	var vel_player = get_parent().find_child('Player').get('velocity')
	# Kira fluctuation and movement
	if vel_player.x != 0:
		bias = sign(vel_player.x)
	rot += 1
	OFFSET.x = sin(2*PI*rot*0.01)*HORIZONTAL_FLOAT_AMPLITUDE + HORIZONTAL_OFFSET*bias
	OFFSET.y = cos(2*PI*rot*0.01)*VERTICAL_FLOAT_AMPLITUDE + VERTICAL_OFFSET
	if rot > 100: rot = 0

	var kira_mov = (position - pos_player + OFFSET)*SPEED
	velocity = -kira_mov*delta
	move_and_slide()
