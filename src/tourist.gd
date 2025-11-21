class_name Tourist
extends Node3D

@onready var handle: Node3D = %Handle

var is_walking: bool = false
var is_left_side: bool = false

func start_stumbling(delay: float = 0.0) -> void:
	var target_x = randf_range(.5, 5.5)
	if is_left_side:
		target_x = - target_x
	
	if (delay > 0.0):
		await get_tree().create_timer(delay).timeout
	
	var stumble_duration = randf_range(1.0, 2.0)
	await walk(target_x, stumble_duration)

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
	var v = pingpong(x * .69, .2)
	handle.position.y = v
