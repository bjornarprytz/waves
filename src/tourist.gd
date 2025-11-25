class_name Tourist
extends Node3D

@onready var handle: Node3D = %Handle

@onready var head: MeshInstance3D = %Head
@onready var body: MeshInstance3D = %Body

var is_left_side: bool = false

var walk_tween: Tween

var stumble_target_x: float = randf_range(.5, 5.5)

func tint(color: Color) -> void:
	for texture in [head, body] as Array[MeshInstance3D]:
		var mat = texture.mesh.surface_get_material(0).duplicate() as StandardMaterial3D
		mat.albedo_color = color
		texture.set_surface_override_material(0, mat)

func start_stumbling(delay: float = 0.0) -> void:
	if is_left_side:
		stumble_target_x = - stumble_target_x
	
	if (delay > 0.0):
		await get_tree().create_timer(delay).timeout
	
	var stumble_duration = randf_range(1.0, 2.0)
	await walk(stumble_target_x, stumble_duration)

func walk(x: float, duration: float):
	if (walk_tween):
		walk_tween.kill()
	
	walk_tween = create_tween().set_ease(Tween.EASE_IN_OUT)
	walk_tween.set_parallel()
	walk_tween.tween_property(handle, "position:x", x, duration)
	walk_tween.tween_method(steps, 0.0, x, duration)
	
	await walk_tween.finished

func flee(car: Car):
	if (walk_tween):
		walk_tween.kill()
		print("Aborted walk tween for flee")
	
	var my_x = handle.global_position.x
	var target_x = car.global_position.x
	var fear_factor = .69
	if (my_x > target_x):
		fear_factor = - fear_factor
	
	var flee_duration = randf_range(.2, .5)
	walk_tween = create_tween()
	walk_tween.set_parallel()
	walk_tween.tween_property(handle, "position:x", fear_factor, flee_duration).as_relative()
	walk_tween.tween_method(steps, handle.position.y, 0.0, flee_duration)
	
	if (walk_tween):
		await walk_tween.finished


func steps(x: float):
	var v = pingpong(x * .69, .2)
	handle.position.y = v
