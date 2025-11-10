class_name Building
extends Node3D

@onready var house: MeshInstance3D = %House
@onready var roof: MeshInstance3D = %Roof


func _ready() -> void:
	_randomize()

func _randomize():
	var height = randf_range(2.0, 4.0)
	var width = randf_range(1.0, 4.0)
	var length = randf_range(1.0, 2.0)
	
	house.scale = Vector3(width, height, length)

	var roof_height = randf_range(0.69, 1.29)
	roof.scale = Vector3(width * 1.1, roof_height, length * 1.1)
	roof.position = Vector3(0, height * 0.5 + roof_height * 0.5, 0)
	
	# Set random color for each house
	var house_colors = [
		Color.from_string("16C5FF", Color.PINK),
		Color.from_string("FFE100", Color.PINK),
		Color.from_string("FF0400", Color.PINK),
		Color.WHITE,
		Color.GRAY
		#Color.from_string("42D03D", Color.PINK)
	]
	
	var random_color = house_colors[randi() % house_colors.size()]
	
	# Get the shader material and duplicate it so each instance has its own
	var mat = house.mesh.surface_get_material(0).duplicate() as StandardMaterial3D
	mat.albedo_color = random_color
	# Use set_surface_override_material on the MeshInstance3D, not the mesh
	house.set_surface_override_material(0, mat)
