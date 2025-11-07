extends Node3D

@onready var ground: MeshInstance3D = %Ground
@onready var car: MeshInstance3D = %Car

var degrees_per_meter: float = 0.69
var rads_per_meter: float

var left_bound := -1.5
var right_bound := 1.5
var move_speed := 3.0

var direction := 0

var momentum := 0.0

var acceleration := 2.0
var deceleration := 10.69

func _ready() -> void:
	assert(ground.mesh.top_radius == ground.mesh.bottom_radius)
	
	var r = ground.mesh.top_radius
	
	var circumference_in_meters = r * 2 * PI
	
	degrees_per_meter = circumference_in_meters / 360.0
	rads_per_meter = deg_to_rad(degrees_per_meter)
	
	print ("Circumference: %f" % circumference_in_meters)
	print ("Rads/meter: %f" % rads_per_meter)

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
	
	if (momentum < -0.01):
		car.position.x = move_toward(car.position.x, left_bound, delta * abs(momentum))
		if (car.position.x == left_bound):
			momentum = move_toward(momentum, 0.0, delta * deceleration)
	elif momentum > 0.01:
		car.position.x = move_toward(car.position.x, right_bound, delta * abs(momentum))
		if (car.position.x == right_bound):
			momentum = move_toward(momentum, 0.0, delta * deceleration)
		
	car.rotation.y = -momentum * .269
		
		
