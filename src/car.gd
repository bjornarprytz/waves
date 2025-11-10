class_name Car
extends Node3D

@onready var car: MeshInstance3D = %Car
@onready var tilt_anchor_left: Node3D = %TiltAnchorLeft
@onready var tilt_anchor_right: Node3D = %TiltAnchorRight

var left_bound := -1.5
var right_bound := 1.5
var move_speed := 3.0

var direction := 0

const rubber_band_strength := 20.0
const max_momentum := 6.9
var momentum := 0.0
var inertia := 0.0

var acceleration := 15.0
var deceleration := 10.69


func _process(delta: float) -> void:
	var left_pressed = Input.is_action_pressed("ui_left")
	var right_pressed = Input.is_action_pressed("ui_right")

	inertia = lerp(inertia, momentum, delta * 5.0)
	
	if left_pressed:
		if (momentum > 0.0):
			momentum += inertia * 0.5 * delta
		momentum -= (acceleration * delta)
	elif right_pressed:
		if (momentum < 0.0):
			momentum -= inertia * 0.5 * delta
		momentum += (acceleration * delta)
	else:
		momentum = move_toward(momentum, 0.0, delta * deceleration)
	
	# Apply rubber band force when past bounds
	if self.position.x < left_bound:
		var distance_past = left_bound - self.position.x
		momentum += rubber_band_strength * distance_past * delta
	elif self.position.x > right_bound:
		var distance_past = self.position.x - right_bound
		momentum -= rubber_band_strength * distance_past * delta
	
	momentum = clamp(momentum, -max_momentum, max_momentum)
	
	# Move self based on momentum
	self.position.x += momentum * delta
	self.rotation.y = - momentum * .169

	# Tilt the car based on momentum. Rotate the car around the z axis of the tilt anchors
	if abs(momentum) < 1.5:
		car.rotation.z = lerp(car.rotation.z, 0.0, delta * 10.0)
	else:
		car.rotation.z = lerp(car.rotation.z, -momentum * 0.069, delta * 10.0)
