extends CharacterBody2D

const MAX_SPEED = 50.0

@onready var health_component : HealthComponent = $HealthComponent

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Called when the node enters the scene tree for the first time.
func _ready():
	#$Area2D.area_entered.connect(on_area_entered)
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction = get_direction_to_player()
	set_velocity(direction * MAX_SPEED)
	move_and_slide()
	add_gravity(delta)


func add_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

func get_direction_to_player():
	var player_node = get_tree().get_first_node_in_group("Player") as Node2D
	if player_node != null: # always null
		print("not null")
		return (player_node.global_position - global_position).normalize()
	return Vector2.ZERO

func on_area_entered(other_area: Area2D):
	health_component.damage(20)
