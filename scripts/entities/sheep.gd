extends CharacterBody2D


@export var max_speed : float = 50.0
@export var jump_velocity : float = -200.0

var direction_old_x: float = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# ----------------------------------------------------------------
# ---------------------_physics_process---------------------------
# ----------------------------------------------------------------
func _physics_process(delta):
	var direction = get_direction_vector_to_player()
	
	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Horizontal movement
	if direction.x != 0:
		velocity.x = direction.x * max_speed
	
	# Way facing
	if (direction.x != 0):
		if ((direction_old_x > 0 and direction.x < 0) or (direction_old_x < 0 and direction.x > 0)):
			Global.change_character_visual_direction(get_node("."))
		direction_old_x = direction.x

	# Jump
	if is_on_floor() and is_on_wall():
		velocity.y = jump_velocity
	
	move_and_slide()

func get_direction_vector_to_player():
	var player_node = get_parent().get_node("Player") as Node2D
	if player_node != null:
		return (player_node.global_position - global_position).normalized()
	return Vector2.ZERO
