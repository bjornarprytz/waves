class_name Tourist
extends Node3D

@onready var handle: Node3D = %Handle

var is_walking: bool = false

func walk(x: float, duration: float):
	if (is_walking):
		return
	is_walking = true
	var walk_tween = create_tween()
	walk_tween.set_parallel()
	walk_tween.tween_property(handle, "position:x", x, duration)
	walk_tween.tween_method(steps, 0.0, x, duration)
	
	await walk_tween.finished
	
	is_walking = false 

func steps(x: float):
	var v = pingpong(x*.69, .2)
	handle.position.y = v
