class_name HonkRange
extends Area3D

@export var car: Car


func _on_area_entered(area: Area3D) -> void:
	if area.owner is Tourist:
		var tourist = area.owner as Tourist
		
		tourist.flee(car)
