class_name Ground
extends MeshInstance3D

@export var rotation_speed: float = 1.0
@export var tourist_frequency: float = .269

const sidewalk_offset: float = 4.0

var _started = false
var _rotation_dimmer := 0.0

var building_spawner = preload("res://building.tscn")
var tourist_spawner = preload("res://tourist.tscn")
var taco_store_spawner = preload("res://taco_store.tscn")

var left_building_range = Vector2(-6, -8)
var right_building_range = Vector2(6, 8)

var degrees_per_meter: float
var rads_per_meter: float

var tourist_spawn_timer: float = 0.0
var next_tourist_spawn: float = 0.0
var current_rotation: float = 0.0 # Track ground rotation


func _ready() -> void:
	assert(self.mesh.top_radius == self.mesh.bottom_radius)
	
	var r = self.mesh.top_radius
	
	var circumference_in_meters = r * 2 * PI
	
	degrees_per_meter = circumference_in_meters / 360.0
	rads_per_meter = deg_to_rad(degrees_per_meter)
	
	print("Circumference: %f" % circumference_in_meters)
	print("Rads/meter: %f" % rads_per_meter)
	
	_spawn_buildings()

func place_taco_store(degrees: float):
	var angle_rad = deg_to_rad(degrees)
	var x = cos(angle_rad) * (self.mesh.top_radius)
	var z = sin(angle_rad) * (self.mesh.top_radius)
	var y = 0.0
	var taco_store_instance = taco_store_spawner.instantiate() as Node3D
	add_child(taco_store_instance)
	taco_store_instance.position = Vector3(x, y, z)

	# Rotate taco store so Y-axis points away from wheel center (outward)
	var outward = Vector3(x, 0, z).normalized()
	var forward = Vector3.UP.cross(outward).normalized()
	var right = outward.cross(forward).normalized()
	
	# Basis with Y-axis = outward, Z-axis = -forward, X-axis = right
	taco_store_instance.basis = Basis(right, outward, forward)
	

func start():
	if (_started):
		push_warning("Attempting a second start")
		return
	
	_started = true
	_reset_tourist_timer()
	var intro_tween = create_tween()
	intro_tween.tween_property(self, "_rotation_dimmer", 1.0, 1.69)

func stop():
	if (not _started):
		push_warning("Attempting to stop when not started")
		return
	
	_started = false
	var outro_tween = create_tween()
	outro_tween.tween_property(self, "_rotation_dimmer", 0.0, .69)

func _physics_process(delta: float) -> void:
	var rotation_delta = rads_per_meter * delta * rotation_speed * _rotation_dimmer
	self.rotate(Vector3.RIGHT, rotation_delta)
	current_rotation += rotation_delta

	if (not _started):
		return
	
	# Handle tourist spawning
	tourist_spawn_timer += delta
	if tourist_spawn_timer >= next_tourist_spawn:
		_spawn_tourist()
		_reset_tourist_timer()
	
	Events.distance_traveled.emit(rotation_delta / rads_per_meter)

func _reset_tourist_timer():
	next_tourist_spawn = tourist_frequency * randf_range(0.5, 1.5)
	tourist_spawn_timer = 0.0

func _spawn_tourist():
	# Fixed world-space angle (behind the camera/horizon)
	var world_spawn_angle_deg = 200.0 # Adjust this to match your red line position
	# Compensate for ground rotation to keep spawn at fixed world position
	var local_angle_rad = deg_to_rad(world_spawn_angle_deg) + current_rotation
	
	var is_left_side = randf() < 0.5
	var base_y = 0.0
	if is_left_side:
		base_y = - sidewalk_offset
	else:
		base_y = sidewalk_offset
	
	var tourist_instance = tourist_spawner.instantiate() as Tourist
	
	var x = cos(local_angle_rad) * self.mesh.top_radius
	var z = sin(local_angle_rad) * self.mesh.top_radius
	var y = base_y + randf_range(-.069, .069)
	
	add_child(tourist_instance)
	tourist_instance.position = Vector3(x, y, z)
	tourist_instance.is_left_side = is_left_side
	
	# Rotate tourist so Y-axis points away from wheel center (outward)
	var outward = Vector3(x, 0, z).normalized()
	var forward = Vector3.UP.cross(outward).normalized()
	var right = - outward.cross(forward).normalized()
	
	# Basis with Y-axis = outward, Z-axis = -forward, X-axis = right
	tourist_instance.basis = Basis(right, outward, -forward)
	
func _spawn_buildings():
	for d in range(360):
		for is_left in [true, false]:
			# Spawn buildings on either side of the road
			var bldg_instance = building_spawner.instantiate() as Building
			var placement = 0.0
			if is_left:
				placement = randf_range(left_building_range.x, left_building_range.y)
			else:
				placement = randf_range(right_building_range.x, right_building_range.y)
			
			var angle_rad = deg_to_rad(d)
			var x = cos(angle_rad) * (self.mesh.top_radius)
			var z = sin(angle_rad) * (self.mesh.top_radius)
			var y = placement
			add_child(bldg_instance)
			bldg_instance.position = Vector3(x, y, z)

			# Rotate building to stand upright and face away from center
			# The outward direction from center
			var outward = Vector3(x, 0, z).normalized()
			# Building's up should be the outward direction
			# Building's forward should point along the wheel's tangent
			var forward = Vector3.UP.cross(outward).normalized()
			var right = outward.cross(forward).normalized()
			
			# Create basis: X=right, Y=up(outward), Z=-forward
			var b = Basis(right, outward, -forward)
			bldg_instance.basis = b

			bldg_instance.add_features(is_left)
