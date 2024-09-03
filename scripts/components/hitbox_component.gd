# handles dealing damage
extends Area2D
class_name HitboxComponent

@export var damage_dealt : int = 10

# ----------------------------------------------------------------
# -----------------------------ready------------------------------
# ----------------------------------------------------------------
func _ready():
	area_entered.connect(on_hitbox_entered)

func on_hitbox_entered(_other_area: HurtboxComponent):
	pass

func get_damage_dealt():
	return damage_dealt
