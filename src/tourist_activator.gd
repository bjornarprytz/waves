extends Area3D


func _on_area_entered(area: Area3D) -> void:
	if area.owner is Tourist:
		var tourist = area.owner as Tourist
		tourist.start_stumbling()
