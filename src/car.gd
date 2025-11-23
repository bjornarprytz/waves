class_name Car
extends Node3D

const CAR_HORN = preload("uid://oaxmdv814w57")

@export var honk_range: float = 150.0

@onready var car: MeshInstance3D = %Car

@onready var wave_left: CPUParticles3D = %WaveLeft
@onready var wave_right: CPUParticles3D = %WaveRight

@onready var sound_source: AudioStreamPlayer3D = %SoundSource
@onready var honk_aoe: Area3D = %HonkRange

var _is_honking: bool = false

var is_invincible: bool = false

var left_bound := -3.5
var right_bound := 3.5
var move_speed := 3.0

var direction := 0

const rubber_band_strength := 30.0
const max_momentum := 5.9

# From being outside the bounds
var extra_momentum := 0.0

var prev_momentum := 0.0
var momentum := 0.0
var inertia := 0.0

var acceleration := 10.0
var deceleration := 5.69

func _process(delta: float) -> void:
	var left_pressed = Input.is_action_pressed("steer_left")
	var right_pressed = Input.is_action_pressed("steer_right")

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
	
	var change = momentum - prev_momentum
	
	if (abs(change) > 0.139):
		if (change < 0):
			wave_left.emitting = false
			wave_right.emitting = true
		else:
			wave_right.emitting = false
			wave_left.emitting = true
	else:
		wave_right.emitting = false
		wave_left.emitting = false
		
	
	# Move self based on momentum
	self.position.x += (momentum + extra_momentum) * delta
	self.rotation.y = - (momentum + extra_momentum) * .169
	
	prev_momentum = momentum

	Events.car_movement.emit(abs(change))

	
func _unhandled_input(event: InputEvent) -> void:
	if (event.is_action_pressed("honk")):
		_honk()

func _honk():
	if (_is_honking):
		return
	
	
	_is_honking = true
	sound_source.stream = CAR_HORN
	sound_source.play()
	
	honk_aoe.show()
	var tween = create_tween()
	tween.tween_property(honk_aoe, "scale", Vector3.ONE * honk_range, CAR_HORN.get_length())
	
	Events.honk_made.emit()
	await tween.finished
	
	honk_aoe.scale = Vector3.ONE
	honk_aoe.hide()
	
	_is_honking = false
	

func _on_hit_box_area_entered(area: Area3D) -> void:
	if area.owner is Tourist:
		Events.tourist_hit.emit(area.owner)
		area.owner.queue_free()
		if is_invincible:
			return
		is_invincible = true
		for i in range(5):
			car.hide()
			await get_tree().create_timer(.169).timeout
			car.show()
			await get_tree().create_timer(.169).timeout
		is_invincible = false
