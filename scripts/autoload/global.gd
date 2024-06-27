extends Node

# ---------------------position---------------------------

var saved_pos_x = 10
var saved_pos_y = 10

func save_pos(x, y):
	saved_pos_x = x
	saved_pos_y = y

func get_saved_x():
	return saved_pos_x

func get_saved_y():
	return saved_pos_y
	
# ---------------------player movement---------------------------
var player_can_move = true

func set_player_can_move(state):
	player_can_move = state

func get_player_can_move():
	return player_can_move
	
# ---------------------door---------------------------
	
var in_door = false

func set_in_door_status(state):
	in_door = state

func get_in_door_status():
	return in_door

func travel_through_door(player_sprite, destination): #player_sprite = $Player/AnimatedSprite2D
	# play door animation and wait until finished
	set_player_can_move(false)
	player_sprite.play("door_enter")
	await get_tree().create_timer(player_sprite.get_playing_speed()).timeout
	# go through door
	get_tree().change_scene_to_file(destination)
	set_player_can_move(true)

func inside_door(body, player, door_sprite): #body, $Player, $Player/AnimatedSprite2D
	if body == player:
		set_in_door_status(true)
		door_sprite.set_self_modulate(Color(0.545098, 0, 0, 1))

func outside_door(body, player, door_sprite):
	if body == player:
		set_in_door_status(false)
		door_sprite.set_self_modulate(Color(1, 1, 1, 1))


