extends Node2D

const max_range = 5000

@export var based_width: float = 15
@export var speed: float = 100
@export var beam_dist_from_center: float = 6
@export var damage_dealt: float = 10
@export var active: bool = false

@export var start_point: Marker2D
@export var end_point: Marker2D

@onready var path_position: Vector2 = start_point.global_position

@onready var ray_cast = $RayCast2D
@onready var line = $Line2D
@onready var hitbox = $Line2D/HitboxComponent
@onready var collision_line = $Line2D/HitboxComponent/CollisionShape2D

@onready var collision_sparks = $CollisionSparks
@onready var charge_ani = $Charge

# ----------------------------------------------------------------
# -----------------------------ready------------------------------
# ----------------------------------------------------------------
func _ready():
	hitbox.set_damage_dealt(damage_dealt)

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
			move_between_points(start_point.global_position, end_point.global_position, speed, delta)
			update_angles_and_positions()
	else:
		set_visible(false)
		collision_line.set_disabled(true)


func move_between_points(start: Vector2, end: Vector2, speed, delta):
	if path_position == null:
		path_position = start
	
	# calculate ratio to move in
	var x_increment = (end.x - start.x) / 100
	var y_increment = (end.y - start.y) / 100
	
	# move along path
	if path_position.x < end.x and path_position.y < end.y:
		path_position.x += x_increment * speed * delta
		path_position.y += y_increment * speed * delta
	
	# convert to local coords, extend to go until walls, and set as target
	var max_cast_to = to_local(path_position).normalized() * max_range
	ray_cast.target_position = max_cast_to

func update_angles_and_positions():
	if ray_cast.is_colliding():
		collision_sparks.global_position = ray_cast.get_collision_point()
		print(collision_sparks.global_position.x)
		
		line.set_point_position(0, Vector2(beam_dist_from_center*cos(line.points[1].angle()), beam_dist_from_center*sin(line.points[1].angle()) ))
		line.set_point_position(1, line.to_local(collision_sparks.global_position))
		
		collision_line.shape.b = line.to_local(collision_sparks.global_position)
	else:
		collision_sparks.global_position = ray_cast.target_position
		
		line.points[1] = collision_sparks.global_position
		collision_line.shape.b = collision_sparks.global_position
	
	# start and end rotate with line
	collision_sparks.rotation = line.points[1].angle()
	charge_ani.rotation = line.points[1].angle()

func activate_laser():
	active = true

func deactivate_laser():
	active = false
