extends CharacterBody2D

@export var GRAVITY = 9.8
@export var AIR_GRAVITY_FRICTION = 10
@export var ACCELERATION = 5
@export var FRICTION = 8
@export var MAX_SPEED = 2
@export var JUMP_MULTIPLIER = 3
@export var WALL_FRICTION = 7

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Parameters multiplier to easily tweak them from the editor
	var params_multiplier = 100 
	#don't touch this unless you are very sure of what you are doing
	GRAVITY = GRAVITY*params_multiplier
	AIR_GRAVITY_FRICTION = AIR_GRAVITY_FRICTION*params_multiplier
	ACCELERATION = ACCELERATION*params_multiplier
	FRICTION = FRICTION*params_multiplier
	MAX_SPEED = MAX_SPEED*params_multiplier
	JUMP_MULTIPLIER = JUMP_MULTIPLIER*params_multiplier
	WALL_FRICTION = WALL_FRICTION*params_multiplier

func movement_input():
	var input_vector = Vector2.ZERO
	input_vector = Vector2(
		int(Input.is_action_pressed('RIGHT'))-int(Input.is_action_pressed('LEFT')),
		-int(Input.is_action_just_pressed("JUMP"))
	)
	return input_vector

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	velocity.y += delta*GRAVITY

	velocity.x += delta*ACCELERATION*movement_input().x
	if is_on_floor_only():
		velocity.y += JUMP_MULTIPLIER*movement_input().y
	if is_on_wall():
		velocity.y += JUMP_MULTIPLIER*movement_input().y*0.9 - WALL_FRICTION*delta*clamp(sign(velocity.y),0,1)
	
	if movement_input() == Vector2.ZERO:
		velocity = velocity.move_toward(Vector2(0,velocity.y), delta*FRICTION)
	velocity = velocity.clamp(Vector2(-MAX_SPEED, -AIR_GRAVITY_FRICTION), Vector2(MAX_SPEED, AIR_GRAVITY_FRICTION))

	move_and_slide()
