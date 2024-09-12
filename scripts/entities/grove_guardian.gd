extends CharacterBody2D

@export var max_speed : float = 50.0

# references to subcomponents
@export var laser_one: LaserComponent
@export var laser_two: LaserComponent

@onready var animation = $AnimationPlayer
@onready var health_component: HealthComponent = $HealthComponent
@onready var direction_component: DirectionComponent = $DirectionComponent
@onready var boss_battle_component: BossBattleComponent = get_parent().get_node("BossBattleComponent")

# finite state machine signals
signal to_idle_state
signal to_follow_state
signal to_laser_state

# finite state machine variables
var is_following: bool = false
var start: bool = false

# ----------------------------------------------------------------
# -----------------------------ready------------------------------
# ----------------------------------------------------------------
func _ready():
	# signals
	to_idle_state.connect(idle_state)
	to_follow_state.connect(follow_state)
	to_laser_state.connect(laser_state)
	
	health_component.died.connect(death_state)
	health_component.health_change.connect(on_hurt)
	laser_one.laser_destination_reached.connect(laser_reached_destination)
	
	# to start
	to_idle_state.emit()


# ----------------------------------------------------------------
# ---------------------_physics_process---------------------------
# ----------------------------------------------------------------
func _physics_process(delta):
	if is_following:
		move(direction_component.get_direction_vector_to_player())

func move(direction):
	# Horizontal movement
	if direction.x != 0:
		velocity.x = direction.x * max_speed

	# Vertical movement
	if direction.y != 0:
		velocity.y = direction.y * max_speed

	move_and_slide()

# ----------------------------------------------------------------
# ---------------------finite_state_machine-----------------------
# ----------------------------------------------------------------

# right now, starts as idle, until it is hurt
# it then switches to laser
# and once the laser is done, it switches to follow

# ---------- idle
func idle_state():
	animation.play("Idle")

func on_hurt(_heal):
	if not start:
		boss_battle_component.start_boss_battle()
		start = true
		to_laser_state.emit()


# ---------- follow
func follow_state():
	is_following = true
	animation.play("Idle")


# ---------- laser
func laser_state():
	is_following = false
	animation.play("Idle")

	# TODO: when lasers are first activated, have charge period, see laser_component todo
	# TODO: also, for when state machine gets more complicated later, have boss move towards the center while charging laser
	laser_one.activate_laser()
	laser_two.activate_laser()

func laser_reached_destination():
	laser_one.deactivate_laser()
	laser_two.deactivate_laser()

	to_follow_state.emit()


# ---------- death
func death_state():
	boss_battle_component.end_boss_battle()
	queue_free()
