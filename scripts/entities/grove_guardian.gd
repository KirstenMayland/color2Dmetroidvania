extends CharacterBody2D

@export var max_speed : float = 50.0

# references to subcomponents
@onready var animation = $AnimationPlayer
@onready var health_component: HealthComponent = $HealthComponent
@onready var direction_component: DirectionComponent = $DirectionComponent
@export var laser_one: LaserComponent
@export var laser_two: LaserComponent

# finite state machine variables
@onready var in_idle_state = true
var in_follow_state = false
var in_laser_state = false
var in_death_state = false

# ----------------------------------------------------------------
# -----------------------------ready------------------------------
# ----------------------------------------------------------------
func _ready():
	health_component.died.connect(on_death)
	health_component.health_change.connect(on_hurt)
	
	laser_one.laser_destination_reached.connect(laser_reached_destination)

func on_death():
	queue_free()

# ----------------------------------------------------------------
# ---------------------_physics_process---------------------------
# ----------------------------------------------------------------
func _physics_process(_delta):
	finite_state_machine()


# right now, starts as idle, until it is hurt
# it then switches to laser
# and once the laser is done, it switches to follow

func finite_state_machine():
	if in_idle_state:
		idle_state()
	elif in_follow_state:
		follow_state()
	elif in_laser_state:
		laser_state()
	elif in_death_state:
		death_state()

# TODO: unfortunately no pointers, so figure out a way to cleanly change between states without looping

func idle_state():
	animation.play("Idle")

func on_hurt(heal):
	in_idle_state = false
	in_laser_state = true


func follow_state():
	animation.play("Idle")
	move(direction_component.get_direction_vector_to_player())

func move(direction):
	# Horizontal movement
	if direction.x != 0:
		velocity.x = direction.x * max_speed
	
	# Vertical movement
	if direction.y != 0:
		velocity.y = direction.y * max_speed
	
	move_and_slide()


func laser_state():
	animation.play("Idle")
	# TODO: when lasers are first activated, have charge period
	laser_one.activate_laser()
	laser_two.activate_laser()

func laser_reached_destination():
	laser_one.deactivate_laser()
	laser_two.deactivate_laser()
	in_laser_state = false
	in_follow_state = true


# should probably have on_death signal go straight here
func death_state():
	pass
