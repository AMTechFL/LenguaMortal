extends Area3D

signal choice_clicked(word_index)

@onready var label: Label3D = $Label3D
@onready var mesh: MeshInstance3D = $MeshInstance3D

var assigned_index: int = -1

func setup(word_index: int, word_text: String) -> void:
	assigned_index = word_index
	if label:
		label.text = str(word_text)

func clear_label() -> void:
	if label:
		label.text = ""

func set_color(color: Color) -> void:
	if mesh:
		# Create or reuse a StandardMaterial3D on the mesh
		var mat = mesh.get_surface_override_material(0)
		if mat == null:
			mat = StandardMaterial3D.new()
			mesh.set_surface_override_material(0, mat)
		
		# Set the albedo color
		mat.albedo_color = color

func interact() -> void:
	emit_signal("choice_clicked", assigned_index)
