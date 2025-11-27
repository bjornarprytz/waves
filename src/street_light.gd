class_name StreetLight
extends Node3D

var active := false
var flickering := false
@onready var light: SpotLight3D = %Light

func turn_off():
	light.hide()
	active = false
	
func turn_on():
	light.show()
	active = true


var proc_check := 0.0
var proc_interval := 0.1

func _process(_delta: float) -> void:
	proc_check += _delta
	if proc_check >= proc_interval:
		proc_check = 0.0
		if (active && not flickering && randf() < 0.01):
			flicker()
	
func flicker():
	flickering = true
	var flicker_tween = create_tween().set_ease(Tween.EASE_IN_OUT)
	flicker_tween.tween_property(light, "light_energy", 0.0, 0.1)
	flicker_tween.tween_property(light, "light_energy", 1.0, 0.1)
	flicker_tween.set_loops(randi() % 5 + 2)
	
	await flicker_tween.finished
	flickering = false
		
