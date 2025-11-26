class_name HeartIcon
extends TextureRect

var is_flashing := false

func blink_away():
	if (is_flashing):
		return
	is_flashing = true
	for i in range(5):
		hide()
		await get_tree().create_timer(.169).timeout
		if i == 4:
			break
		show()
		await get_tree().create_timer(.169).timeout
	is_flashing = false
