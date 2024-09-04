extends TextureProgressBar

# Node paths to the player and the camera
@onready var player = get_parent().get_parent().get_node("Player") as Player
@onready var player_health_component = player.get_node("HealthComponent") as HealthComponent

# Called when the node enters the scene tree for the first time.
func _ready():
	player_health_component.health_change.connect(update)
	update()

func update():
	# TODO: not representing 90 health or 10 health (takes 10 hits but bar only moves 7 times)
	value = (player_health_component.get_current_health() * 100) / player_health_component.get_max_health()
