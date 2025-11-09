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
