extends RigidBody2D

@export var HIT_DAMAGE = 0.5
var is_falling = true

func _ready() -> void:
	gravity_scale = 0


func _on_trigger_body_entered(_body: Node2D) -> void:
	gravity_scale = 1

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.name == 'Player' and is_falling:
		body.damage(HIT_DAMAGE, position)
	else:
		is_falling = false
		set_collision_layer_value(4, false)
		set_collision_mask_value(4, false)
