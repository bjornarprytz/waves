class_name HouseWindow
extends Node3D

@onready var pane: MeshInstance3D = %Pane

func change_hue(color: Color):
	# Change the hue of the window pane material
	var mat = pane.mesh.surface_get_material(0).duplicate() as StandardMaterial3D

	mat.albedo_color = color
	pane.set_surface_override_material(0, mat)
	

func turn_on_light() -> void:
	# Set emission to true
	var mat = pane.mesh.surface_get_material(0).duplicate() as StandardMaterial3D
	mat.emission_enabled = true
	pane.set_surface_override_material(0, mat)

func turn_off_light() -> void:
	# Set emission to false
	var mat = pane.mesh.surface_get_material(0).duplicate() as StandardMaterial3D
	mat.emission_enabled = false
	pane.set_surface_override_material(0, mat)
