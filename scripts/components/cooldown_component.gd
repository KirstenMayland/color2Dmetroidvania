extends Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("timeout", self, "_on_damage_cooldown_timeout")



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_damage_cooldown_timeout():
	# This function is called when the cooldown period ends (optional)
	print("Player can take damage again")
