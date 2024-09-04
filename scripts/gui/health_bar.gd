extends TextureProgressBar

# Node paths to the player and the camera
@onready var player = get_parent().get_parent().get_node("Player") as Player
@onready var player_health_component = player.get_node("HealthComponent") as HealthComponent

# Called when the node enters the scene tree for the first time.
func _ready():
#	set_step(100)
	update_bar()
	player_health_component.health_change.connect(update_bar)

func update_bar():
	# TODO: not representing 90 health or 10 health (takes 10 hits but bar only moves 7 times)
	set_value(clamp((player_health_component.get_current_health() * 100) / player_health_component.get_max_health(), 0, 100))
	print(get_value())
#	print(get_progress_texture())
#	.set_progress_texture(value)


