extends Node3D

# Load the corridor scene dynamically to avoid circular resource dependencies
const CORRIDOR_SCENE = preload("res://scenes/corridor.tscn")

@onready var detection: Area3D = $Detection
@onready var marker_3d: Marker3D = find_child("Marker3D", true, false) as Marker3D

var has_spawned: bool = false

func _ready() -> void:
	if detection:
		detection.body_entered.connect(_on_detection_body_entered)

func _on_detection_body_entered(body: Node3D) -> void:
	if not has_spawned and (body.is_in_group("player") or body.name == "Player"):
		has_spawned = true
		spawn_next_corridor()

func spawn_next_corridor() -> void:
	if marker_3d == null:
		print("Error: Could not find Marker3D node!")
		return
		
	# Instantiate using the preloaded constant
	var next_corridor = CORRIDOR_SCENE.instantiate()
	get_parent().add_child(next_corridor)
	next_corridor.global_transform = marker_3d.global_transform
