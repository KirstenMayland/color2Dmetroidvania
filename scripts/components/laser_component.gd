extends Node2D

const max_range = 5000

@export var based_width: float = 15
@export var beam_dist_from_center: float = 6
@export var damage_dealt: float = 10
@export var active: bool = true

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
		update_path()
		update_angles_and_positions()
	else:
		set_visible(false)
		collision_line.set_disabled(true)


func update_path():
	var mouse_position = get_local_mouse_position()
	var max_cast_to = mouse_position.normalized() * max_range
	ray_cast.target_position = max_cast_to

func update_angles_and_positions():
	if ray_cast.is_colliding():
		collision_sparks.global_position = ray_cast.get_collision_point()
		
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
