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
	
# ---------------------door---------------------------
	
var in_door = false
	
func set_in_door(state):
	in_door = state

func get_in_door():
	return in_door
