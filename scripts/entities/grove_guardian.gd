extends CharacterBody2D

@export var max_speed : float = 100.0

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
signal to_ground_pound_state

# finite state machine variables
var is_following: bool = false
var is_to_laser: bool = false
var is_moving_above: bool = false
var is_ground_pounding: bool = false
var start: bool = false

# ground pound variables
var gp_pause_timer = 0.5  # seconds
var gravity = 2000
var gp_move_speed = 300
var gp_target_position = Vector2()
var gp_min_distance_from_player = 50  # Distance before stopping above the player

# ----------------------------------------------------------------
# -----------------------------ready------------------------------
# ----------------------------------------------------------------
func _ready():
	# signals
	to_idle_state.connect(idle_state)
	to_follow_state.connect(follow_state)
	to_laser_state.connect(laser_state)
	to_ground_pound_state.connect(ground_pound_state)
	
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
	elif is_to_laser:
		global_position = global_position.move_toward(location_to_fire_from.global_position, max_speed * (3.0/5.0) * delta)
	elif is_moving_above:
		move_above_player(delta)
	elif is_ground_pounding:
		ground_pound(delta)

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


# ----------------------------idle------------------------------
func idle_state():
	animation.play("Idle")

# TODO: instead of "on_hurt" it should be "on_attack", we don't need to know if it's hurt or not
func on_hurt(_heal):
	if not start:
		boss_battle_component.start_boss_battle()
		start = true
		to_laser_state.emit()

# ----------------------------death------------------------------
func death_state():
	boss_battle_component.end_boss_battle()
	queue_free()


# ----------------------------------------------------------------
# ----------------------------attack------------------------------

# ----------------------------follow------------------------------
func follow_state():
	is_to_laser = false
	is_following = true
	is_ground_pounding = false
	is_moving_above = false
	animation.play("Idle")


# ----------------------------laser------------------------------
func laser_state():
	is_to_laser = true
	is_following = false
	is_ground_pounding = false
	is_moving_above = false
	animation.play("Idle")

	# TODO: when lasers are first activated, have charge period, see laser_component todo
	laser_one.activate_laser()
	laser_two.activate_laser()

func laser_reached_destination():
	is_to_laser = false
	laser_one.deactivate_laser()
	laser_two.deactivate_laser()

	to_ground_pound_state.emit()


# ----------------------------ground_pound------------------------------
func ground_pound_state():
	is_to_laser = false
	is_following = false
	is_ground_pounding = false 
	is_moving_above = false
	
	start_ground_pound()


func start_ground_pound():
	is_moving_above = true


func move_above_player(delta):
	# calibrate target
	var player_pos = direction_component.get_global_position_of_player()
	gp_target_position = Vector2(player_pos.x, player_pos.y - 200)  # 200 pixels above the player
	
	# Move towards the target position above the player
	global_position = global_position.move_toward(gp_target_position, gp_move_speed * delta)

	# Stop moving once the boss is a certain distance from the player, then plung
	if global_position.distance_to(gp_target_position) < gp_min_distance_from_player:
		is_moving_above = false
		# Pause before plunging down
		await get_tree().create_timer(gp_pause_timer).timeout
		plunge_down()


func plunge_down():
	is_ground_pounding = true
	# TODO: when plunging downward, enable hitbox


func ground_pound(delta):
	# Apply gravity and move downwards
	velocity.y += gravity * delta
	move_and_slide()

	# Check if the boss hits the ground
	if is_on_floor():
		is_ground_pounding = false
		# TODO: hit floor, disable hitbox and add shockwave effect
