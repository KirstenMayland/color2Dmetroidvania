extends CharacterBody2D


@export var max_speed : float = 50.0
@export var jump_velocity : float = -200.0

@onready var health_component: HealthComponent = $HealthComponent
var direction_old_x: float = 1
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# ----------------------------------------------------------------
# -----------------------------ready------------------------------
# ----------------------------------------------------------------
func _ready():
	health_component.died.connect(on_death)

func on_death():
	queue_free()


# ----------------------------------------------------------------
# ---------------------_physics_process---------------------------
# ----------------------------------------------------------------
func _physics_process(delta):
	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	move(get_direction_vector_to_player())

func move(direction):
	# Horizontal movement
	if direction.x != 0:
		velocity.x = direction.x * max_speed
		
		# Way facing
		if ((direction_old_x > 0 and direction.x < 0) or (direction_old_x < 0 and direction.x > 0)):
			Global.change_character_visual_direction(get_node("."))
		direction_old_x = direction.x

	# Jump
	if is_on_floor() and is_on_wall():
		velocity.y = jump_velocity
	
	move_and_slide()

func get_direction_vector_to_player():
	var core_node = get_parent().get_node("Core")
	if core_node != null:
		var player_node = core_node.get_node("Player") as Player
		if player_node != null:
			return (player_node.global_position - global_position).normalized()
	return Vector2.ZERO
