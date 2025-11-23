class_name StatsUI
extends Control

var stats_entry_spawner = preload("res://stats_entry.tscn")
@onready var entry_container: VBoxContainer = %EntryContainer

var _game: Game

func update(game: Game):
    _game = game
    for child in entry_container.get_children():
        child.queue_free()
    
    create("Tourists Avoided", str(game.tourists_avoided))
    create("Houses Startled", str(game.houses_startled))
    create("Honks Made", str(game.honks))
    create("Tourists Hit", str(game.tourists_hit))
    create("Longest Streak", str(game.longest_streak))
    create("Manouver", str(int(game.car_movement)))
    create("Distance Traveled", "%sm" % str(int(game.distance_traveled)))
    create("Lives Left", str(game.lives))


func create(header: String, value: String) -> void:
    var stats_entry_instance = stats_entry_spawner.instantiate() as StatsEntry
    
    entry_container.add_child(stats_entry_instance)
    stats_entry_instance.set_it(header, value)

func _on_button_pressed() -> void:
    _game.restart()
