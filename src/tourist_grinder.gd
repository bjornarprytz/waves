class_name TouristGrinder
extends Area3D


func _on_area_entered(area: Area3D) -> void:
	if area.owner is Tourist:
		Events.tourist_avoided.emit(area.owner)
		area.owner.queue_free()
	if area.owner is StreetLight:
		area.owner.turn_off()
