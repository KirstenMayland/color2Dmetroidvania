# handles recieving damage
extends Area2D
class_name HurtboxComponent

@export var health_component: HealthComponent # used to be Node

# ----------------------------------------------------------------
# -----------------------------ready------------------------------
# ----------------------------------------------------------------
func _ready():
	area_entered.connect(on_hurtbox_entered)

func can_accept_damage_collision():
	# can accept if has health left and not invulnverable
	if health_component.get_invulnerablility():
		return false
	else:
		return health_component.has_health_remaining() 
		
func on_hurtbox_entered(other_area: HitboxComponent):
	# if the other_area was a hitbox
	# and this entity can accept a damage collision (maybe add something about time between attacks)
	# then call damage() on our health component using the damage_dealt amount from the opponent hitbox
	if can_accept_damage_collision():
		print("hiiiiiiiiiiii")
		health_component.damage(other_area.get_damage_dealt())
