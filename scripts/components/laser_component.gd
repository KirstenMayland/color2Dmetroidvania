extends Node2D
class_name LaserComponent

const max_range = 5000

# beam modifications variables
@export var based_width: float = 64
@export var speed: float = 20
@export var beam_dist_from_center: float = 6
@export var damage_dealt: float = 10

# beam usage variables
@export var active: bool = false

# beam path variables
@export var start_point: Marker2D
@export var end_point: Marker2D
@onready var path_position: Vector2

var x_increment: float
var y_increment: float
var x_direction: int
var y_direction: int

# references to subcomponents
# TODO: make Line2D texture and default color + charge sprite + collision sparks sprite exports
@onready var ray_cast = $RayCast2D
@onready var line = $Line2D
@onready var hitbox = $Line2D/HitboxComponent
@onready var collision_line = $Line2D/HitboxComponent/CollisionShape2D
@onready var collision_sparks = $CollisionSparks
@onready var charge_ani = $Charge

# signals
signal laser_destination_reached

# ----------------------------------------------------------------
# -----------------------------ready------------------------------
# ----------------------------------------------------------------
func _ready():
	if start_point and end_point:
		path_pre_calculations(start_point.global_position, end_point.global_position)
	hitbox.set_damage_dealt(damage_dealt)


func path_pre_calculations(start: Vector2, end: Vector2):
	path_position = start
	
	# calculate ratio to move in
	x_increment = (end.x - start.x) / 100
	y_increment = (end.y - start.y) / 100
	
	# calculate relative positions
	x_direction = -1 if (end.x - start.x) < 0 else 1
	y_direction = -1 if (end.y - start.y) < 0 else 1


# ----------------------------------------------------------------
# ----------------------_physics_process--------------------------
# ----------------------------------------------------------------
func _physics_process(delta):
	# set width
	line.width = based_width
	
	if active:
		set_visible(true)
		collision_line.set_disabled(false)
		
		if start_point and end_point:
			move_between_points(end_point.global_position, delta)
			update_angles_and_positions()
		
	else:
		set_visible(false)
		collision_line.set_disabled(true)


func move_between_points(end: Vector2, delta):
	# move along path
	if (path_position.x * x_direction) < (end.x * x_direction) and (path_position.y * y_direction) < (end.y * y_direction):
		path_position.x += x_increment * speed * delta
		path_position.y += y_increment * speed * delta
	else:
		emit_signal("laser_destination_reached")
	
	# convert to local coords, extend to go until walls, and set as target
	var max_cast_to = to_local(path_position).normalized() * max_range
	ray_cast.target_position = max_cast_to


func update_angles_and_positions():
	if ray_cast.is_colliding():
		# put collision art at collision
		collision_sparks.global_position = ray_cast.get_collision_point()
		
		# set end of beam to collision
		line.set_point_position(1, line.to_local(collision_sparks.global_position))
		
		# update collision shape as well
		collision_line.shape.b = line.to_local(collision_sparks.global_position)
	else:
		# put collision art at the end of the beam
		collision_sparks.global_position = ray_cast.target_position
		
		# set end of beam and collision shape to end where it should
		line.points[1] = collision_sparks.global_position
		collision_line.shape.b = collision_sparks.global_position
	
	# move start of beam away from center
	line.set_point_position(0, Vector2(beam_dist_from_center*cos(line.points[1].angle()), beam_dist_from_center*sin(line.points[1].angle()) ))
	
	# start and end rotate with line
	collision_sparks.rotation = line.points[1].angle()
	charge_ani.rotation = line.points[1].angle()


func activate_laser():
	active = true

func deactivate_laser():
	active = false


# TODO: create fire_up_laser function
func fire_up_laser():
	pass
