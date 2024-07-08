# handles recieving damage
extends Area2D
class_name HurtboxComponent

@export var health_component: HealthComponent # used to be Node

func can_accept_damage_collision():
	return health_component.has_health_remaining()
