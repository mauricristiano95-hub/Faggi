extends CharacterBody2D

@export var GRAVITY = 9.8
@export var AIR_GRAVITY_FRICTION = 10
@export var ACCELERATION = 5
@export var FRICTION = 8
@export var MAX_SPEED = 2
@export var JUMP_MULTIPLIER = 3
@export var WALL_FRICTION = 7
@export var DISABLED_INPUT = false

var input_vector = Vector2.ZERO
var input_override = Vector2.ZERO
var spawn_pos = Vector2.ZERO

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
	velocity.x = -backlash_direction.x*1000
	velocity.y = -200
	PlayerStats.set_health(PlayerStats.health-hit_damage)
	
func player_death():
	DISABLED_INPUT = true
	# death animation
	
func player_restart():
	position = spawn_pos
	DISABLED_INPUT = false
	PlayerStats.set_health(PlayerStats.max_health)

func _on_lava_floor_body_entered(_body: Node2D) -> void:
	PlayerStats.set_health(0)
	PlayerStats.set_death_text("Uopsie...")
