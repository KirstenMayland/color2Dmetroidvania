extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$Player.position.x = Global.get_saved_x()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.get_in_door():
		$Player/AnimatedSprite2D.play("door_enter")
		await get_tree().create_timer($Player/AnimatedSprite2D.get_playing_speed()).timeout
		get_tree().change_scene_to_file("res://level_3.tscn")
		Global.set_in_door(false)


func _on_door_body_entered(body):
	if body == $Player:
		Global.set_in_door(true)
