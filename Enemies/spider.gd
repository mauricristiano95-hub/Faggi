extends CharacterBody2D

var rot = 0
var AMPLITUDE = 50
var SPEED = 5

@export var HIT_DAMAGE = 1
@onready var start_pos = $".".position

func _physics_process(delta: float) -> void:
	rot += delta*SPEED*0.1
	position.y = (cos(2*PI*rot+PI)+1)*AMPLITUDE + (cos(2*PI*rot*0.5+PI)+1)*AMPLITUDE/2 + start_pos.y
	if rot > 2: rot = 0

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.name == 'Player':
		body.damage(HIT_DAMAGE, position)
