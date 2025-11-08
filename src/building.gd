class_name Building
extends Node3D

@onready var mesh: MeshInstance3D = %Mesh


func _ready() -> void:
	_randomize()

func _randomize():
	var height = randf_range(2.0, 20.0)	
	var width = randf_range(1.0, 5.0)
	var length = randf_range(1.0, 3.0)
	
	mesh.scale = Vector3(width, height, length)
	
	
