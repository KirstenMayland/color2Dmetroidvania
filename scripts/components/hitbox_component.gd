# handles 
extends Area2D
class_name HitboxComponent

@export var damage_dealt : int = 10

# ----------------------------------------------------------------
# -----------------------------ready------------------------------
# ----------------------------------------------------------------
func _ready():
	area_entered.connect(on_hitbox_entered)

func on_hitbox_entered(other_area: HurtboxComponent):
	# check if player is the one they are trying to damage
	# Note, instead of checking for the player, should just hurt whatever is interacts with that it has been told to on its mask layer
#	var player_node = get_parent().get_node("Player") as Node2D
#	if player_node != null:
#		if other_area.get_parent() != player_node:
#			return
#		print("sheep hitbox entered by player, will hurt player")
#		# if so, damage player
#		var player_health_component = player_node.get_node("HealthComponent") as HealthComponent
#		player_health_component.damage(damage_dealt)
	pass

func get_damage_dealt():
	return damage_dealt
