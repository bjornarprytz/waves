class_name Building
extends Node3D

var window_spawner = preload("res://window.tscn")
var chimney_spawner = preload("res://chimney.tscn")

@onready var house: MeshInstance3D = %House
@onready var roof: MeshInstance3D = %Roof

var windows: Array[HouseWindow] = []
var chimney: Chimney

var height: float
var width: float
var length: float

var is_awake: bool = false

func _ready() -> void:
	_randomize()

func _randomize():
	height = randf_range(2.0, 4.0)
	width = randf_range(1.0, 4.0)
	length = randf_range(1.0, 2.0)
	
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

func add_features(left_side: bool) -> void:
	# Place one or two windows (at half scale) around the middle of the inward face
	var n_windows = 1
	if length > 1.5:
		n_windows = 2
	
	var side = 1 if left_side else -1

	for w in range(n_windows):
		var y_offset = ((length * 0.5) - (n_windows * 0.59) + (w * .69))
		var vertical_placement = ((height / 2) * .69)
		var window_instance = window_spawner.instantiate() as HouseWindow

		add_child(window_instance)
		window_instance.scale = Vector3(0.5, 0.5, 0.5)
		window_instance.position = Vector3(side * (width * 0.5), vertical_placement, y_offset)
		window_instance.rotation = Vector3(0, deg_to_rad(90 * side), 0)
		
		windows.push_back(window_instance)
	
	# Add chimney
	chimney = chimney_spawner.instantiate() as Chimney
	add_child(chimney)
	chimney.position = Vector3(width * 0.2 * side, (height / 2) + (roof.scale.y * 0.7), randf_range(-length * 0.25, length * 0.25))
	chimney.scale = Vector3(0.5, 0.5, 0.5)
		
	if (randf() < 0.3):
		wake()

func wake():
	for w in windows:
		w.turn_on_light()
	chimney.start()
	
