class_name SceneTrigger extends Area2D

@export var connected_scene: String #name of scene to change to

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Player):
	scene_manager.change_scene(body.get_parent().get_parent(), connected_scene)
