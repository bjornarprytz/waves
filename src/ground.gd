class_name Ground
extends MeshInstance3D

@export var rotation_speed: float = 1.0

var building_spawner = preload("res://building.tscn")

var left_building_range = Vector2(-6, -8)
var right_building_range = Vector2(6, 8)

var degrees_per_meter: float
var rads_per_meter: float

func _ready() -> void:
	assert(self.mesh.top_radius == self.mesh.bottom_radius)
	
	var r = self.mesh.top_radius
	
	var circumference_in_meters = r * 2 * PI
	
	degrees_per_meter = circumference_in_meters / 360.0
	rads_per_meter = deg_to_rad(degrees_per_meter)
	
	print("Circumference: %f" % circumference_in_meters)
	print("Rads/meter: %f" % rads_per_meter)
	
	_spawn_buildings()

func _physics_process(delta: float) -> void:
	self.rotate(Vector3.RIGHT, rads_per_meter * delta * rotation_speed)
	
func _spawn_buildings():
	for d in range(360):
		# Spawn buildings on either side of the road
		var bldg_instance = building_spawner.instantiate() as Building
		var is_left = randi() % 2 == 0
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
