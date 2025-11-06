extends Node3D

@onready var ground: MeshInstance3D = %Ground

@export var rotate_speed: float = .69


func _physics_process(delta: float) -> void:
	ground.rotate(Vector3.RIGHT, rotate_speed * delta)
