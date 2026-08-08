extends CharacterBody2D

var rot = 0
var AMPLITUDE = 10
var SPEED = 10
@export var HIT_DAMAGE = 0.5
@onready var start_pos = $".".position


func _physics_process(delta: float) -> void:
	rot += delta*SPEED*0.1
	position.y = (sin(2*PI*rot))*AMPLITUDE + start_pos.y
	position.x = (sin(2*PI*rot*0.5))*AMPLITUDE*2 + start_pos.x
	if rot > 2: rot = 0

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == 'Player':
		var backlash_direction = sign(position-body.position)
		body.velocity.x = -backlash_direction.x*1000
		body.velocity.y = -200
		body.get_node('stats').set_health(body.get_node('stats').health-HIT_DAMAGE)
