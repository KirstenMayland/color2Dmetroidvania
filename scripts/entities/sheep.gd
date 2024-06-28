extends CharacterBody2D


@export var max_speed : float = 50.0
@export var jump_velocity : float = -200.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	var player_node = get_parent().get_node("Player")
	if player_node != null:
		var direction = (player_node.global_position - global_position).normalized()

		# Horizontal movement
		if direction.x != 0:
			velocity.x = direction.x * max_speed
			change_direction(direction.x)

		# Jump if on the ground and close to the player
		if is_on_floor() and abs(player_node.global_position.x - global_position.x) < 100:
			velocity.y = jump_velocity
	else: 
		print("null")
		set_velocity(Vector2.ZERO)
	
	move_and_slide()

# ---------------------change_direction---------------------------
# helper function for move; player faces direction it's moving
func change_direction(direction):
	if direction > 0:
		get_node("AnimatedSprite2D").set_flip_h(false)
	elif direction < 0:
		get_node("AnimatedSprite2D").set_flip_h(true)
		

