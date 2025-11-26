class_name HonkRange
extends Area3D

@export var car: Car


func _on_area_entered(area: Area3D) -> void:
	if area.owner is Tourist:
		var tourist = area.owner as Tourist
		
		tourist.flee(car)
		
	if area.owner is Building:
		var house = area.owner as Building
		
		var was_awake = house.is_awake
		house.wake(20.0)
		if not was_awake:
			Events.house_startled.emit(house)
