extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.position.x = Global.get_saved_x()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print($Player.position.x)
	pass
	
	
func _on_door_body_entered(body):
	print("entered")
	if body == $Player:
		print("hi")
		$Player/AnimatedSprite2D.play("door_enter")
		get_tree().change_scene_to_file("res://level_1.tscn")
		print("why")
