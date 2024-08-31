extends Control

@onready var pause_menu = get_parent().get_node("pause_menu")
var paused = false


func _on_resume_button_pressed():
	pauseMenu()

func _on_exit_button_pressed():
	pauseMenu()
	get_tree().quit()
	
	# TODO: change button so that it brings back to main menu
	#
	# fix bug where it crashes after 1) starting game and switching scenes
	# 2) pausing and exitting to main menu 3) trying to start again
	# get_tree().change_scene_to_file("res://scenes/gui/main_menu.tscn")


func _process(delta):
	if Input.is_action_just_pressed("pause_game"):
		pauseMenu()

func pauseMenu():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
	
	paused = !paused
