class_name Tourist
extends Node3D

var back_body = [preload("res://assets/img/tourist-back-1.png")]
var back_head = [preload("res://assets/img/tourist-head-back-1.png")]

var front_body = [preload("res://assets/img/tourist-body-1.png")]
var front_head = [preload("res://assets/img/tourist-head-1.png")]

@onready var handle: Node3D = %Handle

@onready var head: MeshInstance3D = %Head
@onready var body: MeshInstance3D = %Body
@onready var hit_box: Area3D = %HitBox
@onready var sweat: Node3D = %Sweat

var is_left_side: bool = false

var walk_tween: Tween

var stumble_target_x: float = randf_range(.5, 5.5)
var body_texture: CompressedTexture2D
var head_texture: CompressedTexture2D

func _ready() -> void:
	# Duplicate materials once per instance
	_duplicate_material(body)
	_duplicate_material(head)
	
	var front = randf() < .69

	if (front):
		head_texture = front_head.pick_random()
		body_texture = front_body.pick_random()
	else:
		head_texture = back_head.pick_random()
		body_texture = back_body.pick_random()
	
	# Set textures on duplicated materials
	_set_texture(body, body_texture)
	_set_texture(head, head_texture)

func _duplicate_material(mesh_instance: MeshInstance3D) -> void:
	var mat = mesh_instance.get_surface_override_material(0)
	if mat == null:
		mat = mesh_instance.mesh.surface_get_material(0)
	if mat:
		mat = mat.duplicate()
		mesh_instance.set_surface_override_material(0, mat)

func _set_texture(mesh_instance: MeshInstance3D, texture: Texture2D) -> void:
	var mat = mesh_instance.get_surface_override_material(0)
	if mat:
		mat.set_shader_parameter("texture_albedo", texture)

func tint(color: Color) -> void:
	var flip = randf() < 0.5
	# Use instance shader parameters instead of duplicating materials
	body.set_instance_shader_parameter("tint_color", color)
	body.set_instance_shader_parameter("flip_texture", flip)
	head.set_instance_shader_parameter("tint_color", color)
	head.set_instance_shader_parameter("flip_texture", flip)

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

func cleanup():
	# Hide meshes to prevent material errors when freeing
	body.visible = false
	head.visible = false
	# Clear material references
	body.set_surface_override_material(0, null)
	head.set_surface_override_material(0, null)
