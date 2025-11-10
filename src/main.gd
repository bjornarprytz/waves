extends Node3D

@onready var ground: Ground = %Ground
@onready var car: Car = %Car
@onready var camera: Camera3D = %Camera


func _process(delta: float) -> void:
	# Strafe the camera based on the car's position
	var target_x = car.position.x * 0.5
	camera.position.x = lerp(camera.position.x, target_x, delta * 5.0)
