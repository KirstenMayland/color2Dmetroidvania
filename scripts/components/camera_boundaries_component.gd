extends Area2D

# Node paths to the player and the camera
@onready var player = get_parent().get_node("Player") as Player
@onready var camera = player.get_node("Camera2D")

#@onready var player: Player
#@onready var camera: Camera2D

# Rectangle representing the camera boundaries
var camera_boundaries = Rect2()

func _ready():
	# Get the collision shape and set the boundaries based on its extents
	var pos = $CollisionShape2D.global_position
	var collision_shape = $CollisionShape2D.shape as RectangleShape2D
	camera_boundaries = Rect2(pos - collision_shape.extents, collision_shape.extents * 2)
	
#	player = get_parent().get_node("Player") as Player
#	if player: 
#		camera = player.get_node("Camera2D")
		
func _process(_delta):
	# Ensure the camera stays within the boundaries
	if player and is_instance_valid(camera):
		camera.limit_left = camera_boundaries.position.x
		camera.limit_top = camera_boundaries.position.y
		camera.limit_right = camera_boundaries.position.x + camera_boundaries.size.x
		camera.limit_bottom = camera_boundaries.position.y + camera_boundaries.size.y
