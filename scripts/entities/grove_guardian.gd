extends CharacterBody2D

@export var max_speed : float = 50.0

@onready var animation = $AnimationPlayer

# ----------------------------------------------------------------
# ---------------------_physics_process---------------------------
# ----------------------------------------------------------------
func _physics_process(delta):
	move()
	update_animation_parameters(delta)

func move():
	var direction = get_direction_vector_to_player()

	# Horizontal movement
	if direction.x != 0:
		velocity.x = direction.x * max_speed
	
	# Vertical movement
	if direction.y != 0:
		velocity.y = direction.y * max_speed
	
	move_and_slide()


func get_direction_vector_to_player():
	var player_node = get_parent().get_node("Core").get_node("Player") as Player
	if player_node != null:
		return (player_node.global_position - global_position).normalized()
	return Vector2.ZERO


func update_animation_parameters(_delta):
	animation.play("Idle")
