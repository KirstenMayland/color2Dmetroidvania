extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.position.x = Global.get_saved_x()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Global.get_in_door_status() and Input.is_action_just_pressed("interact"):
		Global.travel_through_door($Player/AnimatedSprite2D, "res://scenes/levels/level_3.tscn")



func _on_door_body_entered(body):
	Global.inside_door(body, $Player, $Door/AnimatedSprite2D)

func _on_door_body_exited(body):
	Global.outside_door(body, $Player, $Door/AnimatedSprite2D)
