class_name Car
extends MeshInstance3D

var left_bound := -1.5
var right_bound := 1.5
var move_speed := 3.0

var direction := 0

const rubber_band_strength := 20.0
const max_momentum := 6.9
var momentum := 0.0

var acceleration := 15.0
var deceleration := 10.69


func _process(delta: float) -> void:
	var left_pressed = Input.is_action_pressed("ui_left")
	var right_pressed = Input.is_action_pressed("ui_right")
	
	if left_pressed:
		if (momentum > 0.0):
			momentum -= (deceleration * delta)
		momentum -= (acceleration * delta)
		print("LEFT  MOMENTUM: %f" % momentum)
	elif right_pressed:
		if (momentum < 0.0):
			momentum += (deceleration * delta)
		momentum += (acceleration * delta)
		print("RIGHT  MOMENTUM: %f" % momentum)
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
