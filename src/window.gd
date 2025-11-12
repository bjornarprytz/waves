class_name HouseWindow
extends Node3D

@onready var pane: MeshInstance3D = %Pane

func _ready() -> void:
	if (randf() < 0.1):
		turn_on_light()

func turn_on_light() -> void:
	# Set emission to true
	var mat = pane.mesh.surface_get_material(0).duplicate() as StandardMaterial3D
	mat.emission_enabled = true
	pane.set_surface_override_material(0, mat)
