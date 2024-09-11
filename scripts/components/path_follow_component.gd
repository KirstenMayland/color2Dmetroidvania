extends Node2D
class_name PathFollowComponent

#@onready var points = $Points

@export var speed: float = 50
@export var rotates: bool = false
@export var loop: bool = true

@onready var points = $Points
@onready var things_to_be_moved = $ToFollowPath

@onready var path = $Path2D
@onready var path_follow = $Path2D/PathFollow2D

# ----------------------------------------------------------------
# -----------------------------ready------------------------------
# ----------------------------------------------------------------
func _ready():
	# add points to path
	if points:
		for point in points.get_children():
			if point is Marker2D:
				path.curve.add_point(point.global_position)
	
	# set variables
	path_follow.rotates = rotates
	path_follow.loop = loop
	
	# move things to be moved where they belong
	things_to_be_moved.reparent(path_follow)

# ----------------------------------------------------------------
# --------------------------_process------------------------------
# ----------------------------------------------------------------
func _process(delta):
	path_follow.progress += speed * delta


func set_speed(value: float):
	speed = value

func set_sprite_rotates(value: bool):
	path_follow.rotates = value

func set_loop(value: bool):
	path_follow.loop = value

# Logical overview:
# 1) component takes child "Points" with marker2D node children and creates a back and forth path between them
# 2) 



# Later, instead of 2 marker nodes, have a variable amount
