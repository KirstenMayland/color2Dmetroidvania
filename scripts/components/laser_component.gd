extends Node2D

const max_range = 5000

@export var based_width: float = 15
@export var beam_dist_from_center: float = 6
@export var damage_dealt: float = 10

@onready var ray_cast = $RayCast2D
@onready var line = $Line2D
@onready var hitbox = $Line2D/HitboxComponent
@onready var collision_line = $Line2D/HitboxComponent/CollisionShape2D

@onready var collision_sparks = $CollisionSparks
@onready var charge_ani = $Charge

# Called when the node enters the scene tree for the first time.
func _ready():
	hitbox.set_damage_dealt(damage_dealt)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	line.width = based_width
	
	var mouse_position = get_local_mouse_position()
	var max_cast_to = mouse_position.normalized() * max_range
	ray_cast.target_position = max_cast_to
	
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
