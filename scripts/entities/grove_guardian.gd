extends CharacterBody2D

@export var max_speed : float = 50.0

@onready var animation = $AnimationPlayer
@onready var health_component: HealthComponent = $HealthComponent
@onready var direction_component: DirectionComponent = $DirectionComponent

# ----------------------------------------------------------------
# -----------------------------ready------------------------------
# ----------------------------------------------------------------
func _ready():
	health_component.died.connect(on_death)

func on_death():
	queue_free()

# ----------------------------------------------------------------
# ---------------------_physics_process---------------------------
# ----------------------------------------------------------------
func _physics_process(delta):
	move(direction_component.get_direction_vector_to_player())
	update_animation_parameters(delta)

func move(direction):
	# Horizontal movement
	if direction.x != 0:
		velocity.x = direction.x * max_speed
	
	# Vertical movement
	if direction.y != 0:
		velocity.y = direction.y * max_speed
	
	move_and_slide()


func update_animation_parameters(_delta):
	animation.play("Idle")
