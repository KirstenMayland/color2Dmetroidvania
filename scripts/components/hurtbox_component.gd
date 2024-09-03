# handles recieving damage
extends Area2D
class_name HurtboxComponent


@export var health_component: HealthComponent
@export var invulnerablilty_timer: Timer
var is_invulnerable: bool = false

@onready var parent = get_parent() as CharacterBody2D

# ----------------------------------------------------------------
# -----------------------------ready------------------------------
# ----------------------------------------------------------------
func _ready():
	area_entered.connect(on_hurtbox_entered)
	if invulnerablilty_timer != null:
		invulnerablilty_timer.timeout.connect(self._on_invulnerablilty_timer_timeout)

func on_hurtbox_entered(other_hitbox: HitboxComponent):
	if can_accept_damage_collision():
		print(str(other_hitbox.get_parent().get_name()) + " hurt " + str(parent.get_name()))
		if invulnerablilty_timer != null:
			start_invulnerablility()
		health_component.damage(other_hitbox.get_damage_dealt())

func can_accept_damage_collision():
	# can accept if has health left and not invulnverable
	if get_invulnerablility():
		return false
	else:
		return health_component.has_health_remaining() 

func _on_invulnerablilty_timer_timeout():
	set_invulnerablility(false)

func start_invulnerablility():
	set_invulnerablility(true)
	invulnerablilty_timer.start()

func set_invulnerablility(boolean: bool):
	is_invulnerable = boolean

func get_invulnerablility():
	return is_invulnerable
