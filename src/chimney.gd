class_name Chimney
extends Node3D

@onready var smoke: CPUParticles3D = %Smoke


func start():
	smoke.emitting = true

func stop():
	smoke.emitting = false
