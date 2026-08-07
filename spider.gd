extends CharacterBody2D

var rot = 0
var AMPLITUDE = 200

func _physics_process(delta: float) -> void:
	rot += 1
	position.y += (sin(2*PI*rot*0.01) + sin(2*PI*rot*0.02))*delta*AMPLITUDE
	if rot > 100: rot = 0

func _on_area_2d_body_entered(body: Node2D) -> void:
	var backlash_direction = sign(position-body.position)
	body.velocity.x = -backlash_direction.x*1000
	body.velocity.y = -200
