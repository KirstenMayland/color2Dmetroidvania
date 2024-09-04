extends TextureProgressBar

@export var player : Player 
@export var character : CharacterBody2D

@onready var background = get_node("HealthBarBackground") as ColorRect

var health_component: HealthComponent

# Called when the node enters the scene tree for the first time.
func _ready():
	if player:
		health_component = player.get_node("HealthComponent") as HealthComponent
	elif character:
		health_component = character.get_node("HealthComponent") as HealthComponent
	
	if health_component:
		update_bar()
		health_component.health_change.connect(update)
	else:
		print("Error: in health_bar.gd, no HealthComponent found")


func update_bar():
	set_value(clamp((health_component.get_current_health() * 100) / health_component.get_max_health(), 0, 100))


func flash_background(background):
	if background:
		background.set_color(Color(1, 1, 1, 1))
		await get_tree().create_timer(0.15).timeout
		background.set_color(Color(0, 0, 0, 1))


func update(heal):
	if not heal:
		flash_background(background)
	
	update_bar()
