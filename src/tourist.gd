class_name Tourist
extends Node3D

@onready var handle: Node3D = %Handle

@onready var head: MeshInstance3D = %Head
@onready var body: MeshInstance3D = %Body
@onready var hit_box: Area3D = %HitBox
@onready var sweat: Node3D = %Sweat

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

func jump_away(car: Car) -> void:
	if (walk_tween):
		walk_tween.kill()
		print("Aborted walk tween for jump_away")

	hit_box.set_deferred("monitorable", false)
	sweat.visible = true
	
	var jump_height = .69
	var jump_duration = 0.469
	var original_y = handle.position.y
	
	# Determine which direction to jump to avoid the car (same logic as flee)
	var my_x = handle.global_position.x
	var car_x = car.global_position.x
	var jump_distance = 1.69
	# Jump away from car: if I'm on the right side of car, jump right (positive)
	if (my_x > car_x):
		jump_distance = - jump_distance
	var target_x = handle.position.x + jump_distance
	
	# Rotate in the direction of the jump (like a goalkeeper dive)
	
	var jump_tween = create_tween().set_ease(Tween.EASE_OUT)
	jump_tween.set_parallel()
	jump_tween.tween_method(steps, handle.position.y, jump_height, jump_duration / 2)
	jump_tween.tween_property(handle, "position:y", jump_height, jump_duration / 2)
	jump_tween.tween_property(handle, "position:x", target_x, jump_duration / 2)
	
	await jump_tween.finished
	
	var fall_tween = create_tween().set_ease(Tween.EASE_IN)
	fall_tween.set_parallel()
	fall_tween.tween_method(steps, handle.position.y, original_y, jump_duration / 2)
	fall_tween.tween_property(handle, "position:y", original_y, jump_duration / 2)
	fall_tween.tween_property(handle, "position:x", target_x, jump_duration / 2)
	fall_tween.tween_property(handle, "rotation:z", 0.0, jump_duration / 2)
	
	await fall_tween.finished

	# Run away and queue free
	await flee(car, 10.69)
	queue_free()

func flee(car: Car, fear_factor: float = 0.69) -> void:
	if (walk_tween):
		walk_tween.kill()
		print("Aborted walk tween for flee")


	sweat.visible = true
	
	var my_x = handle.global_position.x
	var target_x = car.global_position.x
	
	if (my_x > target_x):
		fear_factor = - fear_factor
	
	var flee_duration = randf_range(.2, .5)
	walk_tween = create_tween()
	walk_tween.set_parallel()
	walk_tween.tween_property(handle, "position:x", fear_factor, flee_duration).as_relative()
	walk_tween.tween_method(steps, handle.position.y, 0.0, flee_duration)
	
	if (walk_tween):
		await walk_tween.finished
	
	sweat.visible = false


func steps(x: float):
	var v = pingpong(x * .69, .2)
	handle.position.y = v
