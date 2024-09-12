extends CharacterBody2D

@export var max_speed : float = 50.0

# references to subcomponents
@export var laser_one: LaserComponent
@export var laser_two: LaserComponent
@export var location_to_fire_from: Marker2D

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
var is_to_laser: bool = false
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
func _physics_process(_delta):
	if is_following:
		move(direction_component.get_direction_vector_to_player())
	elif is_to_laser:
		move(direction_component.get_direction_vector_to_point(location_to_fire_from.global_position))

# TODO: fix move such that it just gets close enough and then stays, because right now if it's trying to go to a point
# it overshoots it continuously so it looks like it jitters
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

# start = idle
# middle attacks = laser, follow
# end = death

# TOOO: current plan is create a system, where it randomly goes back and forth between the attack fazes (laser and follow)
# without cutting the laser short


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
	is_to_laser = true
	is_following = false
	animation.play("Idle")

	# TODO: when lasers are first activated, have charge period, see laser_component todo
	# TODO: also, for when state machine gets more complicated later, have boss move towards the center while charging laser
	laser_one.activate_laser()
	laser_two.activate_laser()

func laser_reached_destination():
	is_to_laser = false
	laser_one.deactivate_laser()
	laser_two.deactivate_laser()

	to_follow_state.emit()


# ---------- death
func death_state():
	boss_battle_component.end_boss_battle()
	queue_free()
