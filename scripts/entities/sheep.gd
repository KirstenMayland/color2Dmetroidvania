extends CharacterBody2D


const MAX_SPEED = 100.0
#const JUMP_VELOCITY = -200.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	var direction = get_direction_to_player()
	set_velocity(direction * MAX_SPEED)
	move_and_slide()

func get_direction_to_player():
	var player_node = get_parent().get_node("Player")
	if player_node != null:
		return (player_node.global_position - global_position).normalized()
	return Vector2.ZERO
