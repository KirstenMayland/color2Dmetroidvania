extends CharacterBody2D


const SPEED = 250.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


# ---------------------_physics_process---------------------------
# main function
func _physics_process(delta):
	add_gravity(delta)
	jump()
	move()

# ---------------------add_gravity---------------------------
func add_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta


# ---------------------jump---------------------------
func jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY


# ---------------------move---------------------------
func move():
	var direction = Input.get_axis("move_left", "move_right")
	
	# if moving
	if direction:
		velocity.x = direction * SPEED
		$AnimatedSprite2D.play("walk")
		change_direction(direction)
	
	# if stopped/stopping
	else:
		$AnimatedSprite2D.play("idle")
		velocity.x = move_toward(velocity.x, 0, SPEED / 2)  # stop mechanism, how quickly it slows
	
	move_and_slide()


# ---------------------change_direction---------------------------
# helper function for move; player faces direction it's moving
func change_direction(direction):
	if direction > 0:
		get_node("AnimatedSprite2D").set_flip_h(false)
	elif direction < 0:
		get_node("AnimatedSprite2D").set_flip_h(true)


