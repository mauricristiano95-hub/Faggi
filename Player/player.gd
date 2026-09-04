extends CharacterBody2D

@export var GRAVITY = 9.5
@export var AIR_GRAVITY_FRICTION = 10
@export var ACCELERATION = 5
@export var FRICTION = 8
@export var MAX_SPEED = 2
@export var JUMP_MULTIPLIER = 3
@export var WALL_FRICTION = 9
@export var DISABLED_INPUT = false

var input_vector = Vector2.ZERO
var input_override = Vector2.ZERO
var spawn_pos = Vector2.ZERO
var init_gravity = GRAVITY

@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")

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
	
	spawn_pos = position
	PlayerStats.connect("retry", player_restart)
	PlayerStats.connect("no_health", player_death)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var input_mov = movement_input()
	velocity.y += delta*GRAVITY
	velocity.x += delta*ACCELERATION*input_mov.x
	
	if is_on_floor_only():
		velocity.y += JUMP_MULTIPLIER*input_mov.y
	if is_on_wall():
		velocity.y = JUMP_MULTIPLIER*input_mov.y*0.9 + WALL_FRICTION*delta*clamp(sign(velocity.y),0,1)
		velocity.x -= 60*input_mov.x*(-input_mov.y)
	
	if input_mov == Vector2.ZERO:
		velocity = velocity.move_toward(Vector2(0,velocity.y), delta*FRICTION)
	velocity = velocity.clamp(Vector2(-MAX_SPEED, -AIR_GRAVITY_FRICTION), Vector2(MAX_SPEED, AIR_GRAVITY_FRICTION))
		
	animation(input_mov)
	move_and_slide()

func movement_input():
	input_vector = Vector2.ZERO
	if DISABLED_INPUT == false:
		input_vector = Vector2(
			int(Input.is_action_pressed('RIGHT'))-int(Input.is_action_pressed('LEFT')),
			-int(Input.is_action_just_pressed("JUMP"))
		)
	else:
		input_vector = input_override 
	return input_vector

func damage(hit_damage: float, enemy_pos: Vector2):
	var backlash_direction = sign(enemy_pos-position)
	velocity.x = -backlash_direction.x*1500
	velocity.y = -250
	PlayerStats.set_health(PlayerStats.health-hit_damage)
	
	# damage effect & animation
	animationTree.set("parameters/Damage/blend_position", backlash_direction.x)
	animationState.travel("Damage")
	var tween = create_tween()
	for i in range(3):
		tween.tween_property($Sprite2D, "modulate", Color(1.0, 0.0, 0.0, 1.0), 0.1)
		tween.tween_property($Sprite2D, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.1)
	
func player_death():
	DISABLED_INPUT = true
	# death animation
	animationTree.set("parameters/Damage/blend_position", movement_input())
	animationState.travel("Damage")
	
func player_restart():
	position = spawn_pos
	DISABLED_INPUT = false
	PlayerStats.set_health(PlayerStats.max_health)

func _on_lava_floor_body_entered(_body: Node2D) -> void:
	PlayerStats.set_health(0)
	PlayerStats.set_death_text("Uopsie...")

func animation(input_mov):
	if input_mov != Vector2.ZERO and not is_on_wall_only():
		animationTree.set("parameters/Idle/blend_position", input_mov.x)
		animationTree.set("parameters/Run/blend_position", Vector2(input_mov.x, -input_mov.y))
		animationTree.set("parameters/Climb/blend_position", input_mov.x)
		animationState.travel("Run")
	elif is_on_wall_only():
		animationState.travel("Climb")
	elif not DISABLED_INPUT:
		animationState.travel("Idle")
		
