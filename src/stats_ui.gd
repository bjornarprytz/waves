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
	await create("Tourists Avoided", str(game.tourists_avoided), true)
	await create("Houses Startled", str(game.houses_startled), false)
	await create("Honks Made", str(game.honks), true)
	await create("Tourists Hit", str(game.tourists_hit), false)
	await create("Longest Streak", str(game.longest_streak), true)
	await create("Manouver (lateral)", str(int(game.car_movement)), false)
	await create("Distance Traveled", "%sm" % str(int(game.distance_traveled)), true)
	await create("Lives Left", str(game.lives), false)


func create(header: String, value: String, odd: bool) -> void:
	var stats_entry_instance = stats_entry_spawner.instantiate() as StatsEntry
	
	entry_container.add_child(stats_entry_instance)
	var color = Color(0.1, 0.1, 0.1) if odd else Color(0.2, 0.2, 0.2)
	stats_entry_instance.set_it(header, value, color)
	stats_entry_instance.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(stats_entry_instance, "modulate:a", 1.0, .169)
	await tween.finished

func _on_button_pressed() -> void:
	_game.restart()
