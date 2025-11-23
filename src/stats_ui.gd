class_name StatsUI
extends Control

var stats_entry_spawner = preload("res://stats_entry.tscn")
@onready var entry_container: VBoxContainer = %EntryContainer
@onready var result_label: RichTextLabel = %Result

var _game: Game

func update(game: Game):
	_game = game
	for child in entry_container.get_children():
		child.queue_free()
	
	if (game.taco_acquired):
		result_label.clear()
		result_label.append_text("[rainbow]TACOS acquired!!")
	await create("Tourists Avoided", str(game.tourists_avoided))
	await create("Houses Startled", str(game.houses_startled))
	await create("Honks Made", str(game.honks))
	await create("Tourists Hit", str(game.tourists_hit))
	await create("Longest Streak", str(game.longest_streak))
	await create("Manouver", str(int(game.car_movement)))
	await create("Distance Traveled", "%sm" % str(int(game.distance_traveled)))
	await create("Lives Left", str(game.lives))


func create(header: String, value: String) -> void:
	var stats_entry_instance = stats_entry_spawner.instantiate() as StatsEntry
	
	entry_container.add_child(stats_entry_instance)
	stats_entry_instance.set_it(header, value)
	stats_entry_instance.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(stats_entry_instance, "modulate:a", 1.0, .369)
	await tween.finished

func _on_button_pressed() -> void:
	_game.restart()
