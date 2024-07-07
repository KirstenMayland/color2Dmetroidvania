extends CharacterBody2D


@export var max_speed : float = 50.0
@export var jump_velocity : float = -200.0

@onready var health_component: HealthComponent = $HealthComponent

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	$HurtboxComponent.area_entered.connect(on_area_entered)

func _physics_process(delta):
	var direction = get_direction_to_player()
	
	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Horizontal movement
	if direction.x != 0:
		velocity.x = direction.x * max_speed
		Global.change_animated_sprite_direction(direction.x, get_node("AnimatedSprite2D"))

	# Jump
	if is_on_floor() and is_on_wall():
		velocity.y = jump_velocity
	
	move_and_slide()

func get_direction_to_player():
	var player_node = get_parent().get_node("Player") as Node2D
	if player_node != null:
		return (player_node.global_position - global_position).normalized()
	return Vector2.ZERO
	

func on_area_entered(other_area: Area2D):
	var player_node = get_parent().get_node("Player") as Node2D
	if player_node != null:
		if other_area.get_parent() != player_node:
			return
		var player_health_component = player_node.get_node("HealthComponent") as HealthComponent
		player_health_component.damage(100)
