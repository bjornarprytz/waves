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
	await create("Tourists Avoided", str(game.tourists_avoided), true, true)
	await create("Longest Streak", str(game.longest_streak), false, true)
	await create("Manouver (lateral)", str(int(game.car_movement)), true, true)
	await create("Distance Traveled", "%sm" % str(int(game.distance_traveled)), false, true)
	await create("Honks Made", str(game.honks), true, false)
	await create("Houses Startled", str(game.houses_startled), false, false)
	await create("Tourists Hit", str(game.tourists_hit), true, false)
	var final_score = calc_score(game)
	await create("Final Score", str(final_score), false, true)


func calc_score(game: Game) -> int:
	var score := 0
	score += game.tourists_avoided * int(game.car_movement)
	score += game.longest_streak * int(game.distance_traveled)
	score -= game.houses_startled * 10
	score -= game.honks * 25
	score -= game.tourists_hit * 200
	if (game.taco_acquired):
		score += 1000
	return max(score, 0)

func create(header: String, value: String, odd: bool, positive: bool) -> void:
	var stats_entry_instance = stats_entry_spawner.instantiate() as StatsEntry
	
	entry_container.add_child(stats_entry_instance)
	var color_modifier = 0.1 if odd else 0.2
	var base_color = Color("00b100") if positive else Color("8021ff")
	var color = base_color * (1.0 - color_modifier)

	stats_entry_instance.set_it(header, value, color)
	stats_entry_instance.modulate.a = 0.0
	var tween = create_tween()
	tween.tween_property(stats_entry_instance, "modulate:a", 1.0, .169)
	await tween.finished

func _on_button_pressed() -> void:
	_game.restart()
