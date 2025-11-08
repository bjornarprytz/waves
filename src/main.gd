extends Node3D

@onready var ground: MeshInstance3D = %Ground
@onready var car: MeshInstance3D = %Car

var degrees_per_meter: float = 0.69
var rads_per_meter: float

var left_bound := -1.5
var right_bound := 1.5
var move_speed := 3.0

var direction := 0

const rubber_band_strength := 20.0
const max_momentum := 6.9
var momentum := 0.0

var acceleration := 15.0
var deceleration := 10.69

func _ready() -> void:
	assert(ground.mesh.top_radius == ground.mesh.bottom_radius)
	
	var r = ground.mesh.top_radius
	
	var circumference_in_meters = r * 2 * PI
	
	degrees_per_meter = circumference_in_meters / 360.0
	rads_per_meter = deg_to_rad(degrees_per_meter)
	
	print("Circumference: %f" % circumference_in_meters)
	print("Rads/meter: %f" % rads_per_meter)

func _physics_process(delta: float) -> void:
	ground.rotate(Vector3.RIGHT, rads_per_meter * delta)

func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_left"):
		if (momentum > 0.0):
			momentum -= (deceleration * delta)
		momentum -= (acceleration * delta)
	elif Input.is_action_pressed("ui_right"):
		if (momentum < 0.0):
			momentum += (deceleration * delta)
		momentum += (acceleration * delta)
	else:
		momentum = move_toward(momentum, 0.0, delta * deceleration)
	
	# Apply rubber band force when past bounds
	if car.position.x < left_bound:
		var distance_past = left_bound - car.position.x
		momentum += rubber_band_strength * distance_past * delta
	elif car.position.x > right_bound:
		var distance_past = car.position.x - right_bound
		momentum -= rubber_band_strength * distance_past * delta
	
	momentum = clamp(momentum, -max_momentum, max_momentum)
	
	# Move car based on momentum
	car.position.x += momentum * delta
	car.rotation.y = - momentum * .169
