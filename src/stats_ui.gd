class_name StatsUI
extends CenterContainer

var stats_entry_spawner = preload("res://stats_entry.tscn")

func update(game: Game):
	
	for child in get_children():
		child.queue_free()
	
	create("Tourists Avoided", str(game.tourists_avoided))
	create("Houses Startled", str(game.houses_startled))
	create("Honks Made", str(game.honks))
	create("Tourists Hit", str(game.tourists_hit))
	create("Longest Streak", str(game.longest_streak))


func create(header: String, value: String) -> void:
	var stats_entry_instance = stats_entry_spawner.instantiate() as StatsEntry
	
	stats_entry_instance.set_header(header)
	stats_entry_instance.set_value(value)
	
	add_child(stats_entry_instance)
