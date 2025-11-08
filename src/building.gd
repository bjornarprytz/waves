class_name Building
extends Node3D

@onready var mesh: MeshInstance3D = %Mesh


func _ready() -> void:
	_randomize()

func _randomize():
	var height = randf_range(2.0, 10.0)	
	var width = randf_range(1.0, 4.0)
	var length = randf_range(1.0, 2.0)
	
	mesh.scale = Vector3(width, height, length)
	
	
