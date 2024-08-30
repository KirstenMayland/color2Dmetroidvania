class_name SceneManager extends Node

var core: Core
var last_scene_name: String

var scene_dir_path = "res://scenes/levels/"

func change_scene(from, to_scene_name: String) -> void:
	last_scene_name = from.name
	print(last_scene_name)
	
	core = from.core
	core.get_parent().remove_child(core)
	
	var full_path = scene_dir_path + to_scene_name + ".tscn"
	from.get_tree().call_deferred("change_scene_to_file", full_path)
