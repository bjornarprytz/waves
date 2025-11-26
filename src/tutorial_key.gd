class_name TutorialKey
extends MeshInstance3D



func highlight() -> void:
	var mat := get_surface_override_material(0).duplicate() as StandardMaterial3D
	mat.emission_enabled = true
	set_surface_override_material(0, mat)

func unhighlight() -> void:
	var mat := get_surface_override_material(0).duplicate() as StandardMaterial3D
	mat.emission_enabled = false
	set_surface_override_material(0, mat)
