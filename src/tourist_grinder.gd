class_name TouristGrinder
extends Area3D


func _on_area_entered(area: Area3D) -> void:
	if area.owner is Tourist:
		area.owner.queue_free()
