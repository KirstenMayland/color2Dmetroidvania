extends Node2D
class_name PathFollowComponent

#@onready var points = $Points

@export var speed: float = 50
@export var rotates: bool = false
@export var loop: bool = true

@export var points: Node2D
@export var things_to_be_moved: Node2D

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
var flip = false
func _process(delta):
	path_follow.progress += speed * delta

	if path_follow.progress_ratio >= 0.5:
		for child in things_to_be_moved.get_children():
			if child is CharacterBody2D and not flip:
				flip_sprite(child)
				flip = true
	
	if path_follow.progress_ratio < 0.5:
		for child in things_to_be_moved.get_children():
			if child is CharacterBody2D and flip:
				flip_sprite(child)
				flip = false

func set_speed(value: float):
	speed = value

func set_sprite_rotates(value: bool):
	path_follow.rotates = value

func set_loop(value: bool):
	path_follow.loop = value

func flip_sprite(node : CharacterBody2D):
	Global.change_character_visual_direction(node)
