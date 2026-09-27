extends Area3D

@onready var door: Node3D = get_parent().get_parent() # Button3D is inside Door

func interact() -> void:
	print("BUTTON INTERACTED VIA RAYCAST!")
	if door and door.has_method("open_door"):
		# Global.play_sound("res://audio/sfx/door.ogg")
		door.open_door()
