extends Node2D
class_name DirectionComponent


func get_direction_vector_to_player():
	var character_node = get_parent()
	if character_node != null:
		var core_node = character_node.get_parent().get_node("Core")
		if core_node != null:
			var player_node = core_node.get_node("Player") as Player
			if player_node != null:
				return (player_node.global_position - global_position).normalized()
	return Vector2.ZERO

func get_global_position_of_player():
	var character_node = get_parent()
	if character_node != null:
		var core_node = character_node.get_parent().get_node("Core")
		if core_node != null:
			var player_node = core_node.get_node("Player") as Player
			if player_node != null:
				return player_node.global_position
	return null

func get_direction_vector_to_point(point: Vector2):
	return global_position.direction_to(point)
