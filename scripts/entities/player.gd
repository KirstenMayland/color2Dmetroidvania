class_name Player extends CharacterBody2D


@export var SPEED:float = 250.0
@export var JUMP_VELOCITY:float = -375.0 #jumps just shy of 5 blocks
@export var hurt_animation_length:float = 0.1


@onready var health_component: HealthComponent = $HealthComponent
@onready var animation = $AnimationPlayer
@onready var animation_tree = $AnimationTree


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var direction_old: float = 1

var coyote_time = 0.13
var coyote_time_left = 0.0
var jump_buffer_time = 0.13
var jump_buffer_time_left = 0.0

# animation bools
var heal_ani: bool = false
var hurt_ani: bool = false


# ----------------------------------------------------------------
# -----------------------------ready------------------------------
# ----------------------------------------------------------------
func _ready():
	health_component.health_change.connect(on_health_change)
	animation_tree.active = true

func on_health_change(current_health: float, heal: bool):
	if heal == false:
		hurt_ani = true
		heal_ani = false
	else:
		hurt_ani = false
		heal_ani = true


# ----------------------------------------------------------------
# ---------------------_physics_process---------------------------
# ----------------------------------------------------------------
func _physics_process(delta):
	move()
	jump(delta)
	add_gravity(delta)
	update_animation_parameters(delta)

func move():
	var direction = Input.get_axis("move_left", "move_right")
	# way facing
	if (direction):
		if (direction_old != direction):
			Global.change_character_visual_direction(get_node("."))
		direction_old = direction
	
	# if allowed to run
	if Global.get_player_can_move():
		# if moving
		if direction:
			velocity.x = direction * SPEED
		
		# if stopped/stopping
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED / 2)  # stop mechanism, how quickly it slows
		
		move_and_slide()


func jump(delta):
#	# Update coyote time
	if is_on_floor():
		coyote_time_left = coyote_time
	else:
		coyote_time_left -= delta
	
	# Update jump buffer
	if (Input.is_action_just_pressed("jump")):
		jump_buffer_time_left = jump_buffer_time
	else:
		jump_buffer_time_left -= delta

	# Jump
	if (coyote_time_left > 0 and jump_buffer_time_left > 0):
		velocity.y = JUMP_VELOCITY
		jump_buffer_time_left = 0
	
	if (Input.is_action_just_released("jump")):
		coyote_time_left = 0


func add_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta


func update_animation_parameters(delta):
	# idle
	if velocity == Vector2.ZERO:
		animation_tree["parameters/conditions/idle"] = true
		animation_tree["parameters/conditions/is_moving"] = false
		
		animation_tree["parameters/conditions/in_air"] = false
		animation_tree["parameters/JumpStateMachine/conditions/on_ground"] = true
	# jump
	elif velocity.y != 0:
		animation_tree["parameters/conditions/idle"] = false
		animation_tree["parameters/conditions/is_moving"] = false
		
		animation_tree["parameters/conditions/in_air"] = true
		animation_tree["parameters/JumpStateMachine/conditions/on_ground"] = false
		
		if velocity.y > 0:
			animation_tree["parameters/JumpStateMachine/conditions/jump"] = false
			animation_tree["parameters/JumpStateMachine/conditions/fall"] = true
		else:
			animation_tree["parameters/JumpStateMachine/conditions/jump"] = true
			animation_tree["parameters/JumpStateMachine/conditions/fall"] = false
	# walk
	else: 
		animation_tree["parameters/conditions/idle"] = false
		animation_tree["parameters/conditions/is_moving"] = true
		
		animation_tree["parameters/conditions/in_air"] = false
		animation_tree["parameters/JumpStateMachine/conditions/on_ground"] = true
	
	# jump cont.  ----- Note: x = velocity.y, y = velocity.y v acceleration.y (abs(v.y) > abs(a.y) == 1; abs(v.y) < abs(a.y) == -1)
	animation_tree["parameters/JumpStateMachine/BlendSpace2D/blend_position"] = Vector2(1 if velocity.y > 0 else -1, 1 if abs(velocity.y) >= abs(gravity * delta * 10) else -1)
	
	# slash
	if Input.is_action_just_pressed("attack"):
		animation_tree["parameters/conditions/slash"] = true
	else: 
		animation_tree["parameters/conditions/slash"] = false
	
	# hurt
	if hurt_ani:
		animation_tree["parameters/conditions/hurt"] = true
		hurt_ani = false
	else:
		# reset
		animation_tree["parameters/conditions/hurt"] = false
	
	# through door
