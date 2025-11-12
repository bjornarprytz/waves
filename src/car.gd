class_name Car
extends Node3D

@onready var car: MeshInstance3D = %Car

var left_bound := -3.5
var right_bound := 3.5
var move_speed := 3.0

var direction := 0

const rubber_band_strength := 20.0
const max_momentum := 5.9

# From being outside the bounds
var extra_momentum := 0.0

var momentum := 0.0
var inertia := 0.0

var acceleration := 10.0
var deceleration := 5.69


func _process(delta: float) -> void:
    var left_pressed = Input.is_action_pressed("ui_left")
    var right_pressed = Input.is_action_pressed("ui_right")

    inertia = lerp(inertia, momentum, delta * 5.0)


    # Apply rubber band force when past bounds
    if self.position.x < left_bound:
        var distance_past = left_bound - self.position.x
        extra_momentum += rubber_band_strength * distance_past * delta
        momentum = move_toward(momentum, 0.0, delta * deceleration)
    elif self.position.x > right_bound:
        var distance_past = self.position.x - right_bound
        extra_momentum -= rubber_band_strength * distance_past * delta
        momentum = move_toward(momentum, 0.0, delta * deceleration)
    else:
        extra_momentum = move_toward(extra_momentum, 0.0, delta * rubber_band_strength)
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
    
    
    momentum = clamp(momentum, -max_momentum, max_momentum)
    
    # Move self based on momentum
    self.position.x += (momentum + extra_momentum) * delta
    self.rotation.y = - (momentum + extra_momentum) * .169
