class_name HorizonActivator
extends Area3D

func _on_area_entered(area: Area3D) -> void:
	if area.owner is StreetLight:
		area.owner.turn_on()
