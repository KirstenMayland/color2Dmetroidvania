# handles health values and signaling changes
extends Node2D
class_name HealthComponent

signal died
signal health_change()

@export var max_health: float = 15
var current_health: float

# ----------------------------------------------------------------
# -----------------------------ready------------------------------
# ----------------------------------------------------------------
func _ready():
	current_health = max_health

func damage(damage_amount: float):
	current_health = min(max(current_health - damage_amount, 0), max_health)
	health_change.emit()
	Callable(check_death).call_deferred()

func check_death():
	if current_health == 0:
		died.emit()
		owner.queue_free()

func heal(health: float):
	damage(-health)

func initialize_health():
	current_health = max_health

func has_health_remaining():
	return current_health > 0


# setters and getters -------------------

func set_max_health(health: float):
	max_health = health

func get_max_health():
	return max_health

func get_current_health():
	return current_health
