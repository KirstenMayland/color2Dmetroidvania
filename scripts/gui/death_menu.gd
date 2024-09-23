extends Control

@onready var player_health = get_parent().get_parent().get_node("Player").get_node("HealthComponent")

@onready var death_menu = get_parent().get_node("death_menu")
var death = false

func _on_exit_button_pressed():
	deathMenu()
	get_tree().quit()

func _ready():
	player_health.died.connect(deathMenu)

func deathMenu():
	if death:
		death_menu.hide()
	else:
		death_menu.show()
	
	death = !death
