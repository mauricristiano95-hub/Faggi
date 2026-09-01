extends CharacterBody2D

var rot = 0
var AMPLITUDE = 10
var SPEED = 10
@export var HIT_DAMAGE = 0.5
@export var starting_pos = 0.3
@onready var start_pos = $".".position


func _physics_process(delta: float) -> void:
	rot += delta*SPEED*0.1
	position.y = (sin(2*PI*rot+starting_pos))*AMPLITUDE + start_pos.y
	position.x = (sin((2*PI*rot+starting_pos)*0.5))*AMPLITUDE*2 + start_pos.x
	if rot > 2: rot = 0
	if (position.x - start_pos.x) > 0:
		$Sprite2D.flip_h = false
	else:
		$Sprite2D.flip_h = true
		

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.name == 'Player':
		body.damage(HIT_DAMAGE, position)
