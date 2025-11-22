class_name StatsUI
extends Control

var stats_entry_spawner = preload("res://stats_entry.tscn")
@onready var entry_container: VBoxContainer = %EntryContainer

func update(game: Game):
	
	for child in entry_container.get_children():
		child.queue_free()
	
	create("Tourists Avoided", str(game.tourists_avoided))
	create("Houses Startled", str(game.houses_startled))
	create("Honks Made", str(game.honks))
	create("Tourists Hit", str(game.tourists_hit))
	create("Longest Streak", str(game.longest_streak))


func create(header: String, value: String) -> void:
	var stats_entry_instance = stats_entry_spawner.instantiate() as StatsEntry
	
	entry_container.add_child(stats_entry_instance)
	stats_entry_instance.set_it(header, value)
	
