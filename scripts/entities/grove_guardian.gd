extends CharacterBody2D

@export var max_speed : float = 80.0

# references to subcomponents
@export var laser_one: LaserComponent
@export var laser_two: LaserComponent
@export var location_to_fire_from: Marker2D

@onready var animation = $AnimationPlayer
@onready var health_component: HealthComponent = $HealthComponent
@onready var direction_component: DirectionComponent = $DirectionComponent
@onready var boss_battle_component: BossBattleComponent = get_parent().get_node("BossBattleComponent")
@onready var hitbox_component: HitboxComponent = $HitboxComponent

# finite state machine signals
signal to_idle_state
signal to_laser_state
signal to_ground_pound_state
signal end_of_attack

# Define the different attacks modes
var attacks = ["laser", "ground_pound"]

# finite state machine variables
var is_to_laser: bool = false
var is_moving_above: bool = false
var is_ground_pounding: bool = false
var start: bool = false

# ground pound variables
var gp_pause_timer = 1  # seconds
var gravity = 2000
var gp_move_speed = 300
var gp_target_position = Vector2()
var gp_min_distance_from_player = 50  # Distance before stopping above the player


# ----------------------------------------------------------------
# -----------------------------ready------------------------------
# ----------------------------------------------------------------
func _ready():
	randomize() # Seed the random number generator
	
	# signals
	to_idle_state.connect(idle_state)
	to_laser_state.connect(laser_state)
	to_ground_pound_state.connect(ground_pound_state)
	end_of_attack.connect(attack_state)
	
	# to start fight
	health_component.health_change.connect(on_hurt)
	# to end fight
	health_component.died.connect(death_state)
	
	laser_one.laser_destination_reached.connect(laser_reached_destination)
	laser_two.laser_destination_reached.connect(laser_reached_destination)
	
	# to start
	hitbox_component.get_node("CollisionShape2D").set_disabled(true)
	to_idle_state.emit()


# ----------------------------------------------------------------
# ---------------------_physics_process---------------------------
# ----------------------------------------------------------------
func _physics_process(delta):
	if is_to_laser:
		global_position = global_position.move_toward(location_to_fire_from.global_position, max_speed * (3.0/5.0) * delta)
	elif is_moving_above:
		move_above_player(delta)
	elif is_ground_pounding:
		ground_pound(delta)


# ----------------------------------------------------------------
# ---------------------finite_state_machine-----------------------
# ----------------------------------------------------------------

# ----------------------------idle------------------------------
func idle_state():
	animation.play("Idle")


# ----------------------------death------------------------------
func death_state():
	boss_battle_component.end_boss_battle()
	queue_free()


# ----------------------------------------------------------------
# ----------------------------attacks------------------------------

func on_hurt(_heal): # to start attack phase
	if not start:
		boss_battle_component.start_boss_battle()
		start = true
		end_of_attack.emit()

func attack_state():
	var random_index = randi() % attacks.size()  # Get a random attack
	var selected_attack = attacks[random_index]
	# TOOO: have some way of making sure there's a balanced amount, eg. not 5 lasers in a row
	match selected_attack:
		"laser":
			to_laser_state.emit()
		"ground_pound":
			to_ground_pound_state.emit()


# ----------------------------laser------------------------------
func laser_state():
	is_to_laser = true

	# TODO: when lasers are first activated, have charge period, see laser_component todo
	# TODO: make lasers interesting to dodge, maybe variable path?
	
	# TODO: fix funcking offset things
	var offset: float
	offset = randf_range(-500, 500)
	print(offset)

	laser_one.beam_path_x_offset = offset
	laser_two.beam_path_x_offset = offset
	
	laser_one.activate_laser()
	laser_two.activate_laser()


var total_laser_end: int = 0
func laser_reached_destination(_laser):
	total_laser_end += 1
	laser_end()
	

func laser_end():
	if total_laser_end == 2:
		is_to_laser = false
		laser_one.deactivate_laser()
		laser_two.deactivate_laser()
		total_laser_end = 0
		
		end_of_attack.emit()


# ----------------------------ground_pound------------------------------
func ground_pound_state():	
	start_ground_pound()


func start_ground_pound():
	is_moving_above = true

# TODO: make sure it doesn't glitch into the walls
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
	hitbox_component.get_node("CollisionShape2D").set_disabled(false)

func ground_pound(delta):
	# Apply gravity and move downwards
	velocity.y += gravity * delta
	move_and_slide()

	# Check if the boss hits the ground
	if is_on_floor():
		is_ground_pounding = false
		hitbox_component.get_node("CollisionShape2D").set_disabled(true)
		await get_tree().create_timer(0.5).timeout
		end_of_attack.emit()
		# TODO: add shockwave effect + pause at bottom/rise slowly to allow player to get hits in
