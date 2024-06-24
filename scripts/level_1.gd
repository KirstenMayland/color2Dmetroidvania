extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Player/Camera2D.set_limit(SIDE_TOP, 0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	# set seamless drop
	if $Player.position.y > 2000:
		Global.save_pos($Player.position.x, 0)
		get_tree().change_scene_to_file("res://scenes/level_2.tscn")

