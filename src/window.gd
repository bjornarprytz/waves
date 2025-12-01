class_name HouseWindow
extends Node3D

@onready var pane: MeshInstance3D = %Pane

func _ready() -> void:
	# Duplicate material so each window has independent instance parameters
	var mat = pane.get_surface_override_material(0)
	if mat == null:
		mat = pane.mesh.surface_get_material(0)
	if mat:
		mat = mat.duplicate()
		pane.set_surface_override_material(0, mat)

func change_hue(color: Color):
	# Set shader parameters on duplicated material
	var mat = pane.get_surface_override_material(0)
	if mat:
		mat.set_shader_parameter("light_color", color)

func turn_on_light() -> void:
	var mat = pane.get_surface_override_material(0)
	if mat:
		mat.set_shader_parameter("light_on", true)

func turn_off_light() -> void:
	var mat = pane.get_surface_override_material(0)
	if mat:
		mat.set_shader_parameter("light_on", false)
