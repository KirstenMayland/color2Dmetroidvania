class_name BaseScene extends Node

@onready var core: Core = $Core
@onready var entrance_markers: Node2D = $EntranceMarkers

func _ready():
	if scene_manager.core:
		if core:
			core.name = "_Core"
			core.queue_free()
		
		core = scene_manager.core
		core.name = "Core"
		add_child(core)
	
	position_core()

func position_core() -> void:
	var last_scene = scene_manager.last_scene_name.to_lower().replace('_', '').replace(' ', '')
	if last_scene.is_empty():
		last_scene = "any"
	
	if entrance_markers:
		for entrance in entrance_markers.get_children():
			var entrance_name = entrance.name.to_lower().replace('_', '').replace(' ', '')
				
			if entrance is Marker2D and entrance_name == "any" or entrance_name == last_scene:
				core.get_node("Player").global_position = entrance.global_position
