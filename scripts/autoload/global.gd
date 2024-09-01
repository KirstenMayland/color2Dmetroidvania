extends Node

# ---------------------player movement---------------------------
var player_can_move = true

func set_player_can_move(state):
	player_can_move = state

func get_player_can_move():
	return player_can_move


# ---------------------visuals---------------------------
func change_character_visual_direction(character):
	if character is CharacterBody2D and Engine.time_scale != 0:
		character.scale.x = character.scale.x * -1

