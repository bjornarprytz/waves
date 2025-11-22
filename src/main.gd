class_name Game
extends Node3D

var _game_over_is_flashing = false

@onready var game_over_label: RichTextLabel = %GameOver
@onready var stats_ui: StatsUI = %Stats

var tourists_avoided := 0
var houses_startled := 0
var honks := 0
var tourists_hit := 0

var longest_streak := 0
var current_streak := 0


func _ready() -> void:
	Events.game_over.connect(_on_game_over)
	Events.tourist_avoided.connect(_on_tourist_avoided)
	Events.house_startled.connect(_on_house_startled)
	Events.honk_made.connect(_on_honk)
	Events.tourist_hit.connect(_on_tourist_hit)
	

func _on_game_over(result: bool):
	print("Game over... won? %s!" % result)

	if (_game_over_is_flashing):
		return
	
	_game_over_is_flashing = true	
	for i in range(3):
		game_over_label.show()
		await get_tree().create_timer(0.369).timeout
		game_over_label.hide()
		await get_tree().create_timer(0.369).timeout
	_game_over_is_flashing = false

func _on_honk():
	honks += 1

func _on_tourist_hit(_tourist: Tourist):
	tourists_hit += 1
	current_streak = 0

func _on_house_startled(_house: Building):
	houses_startled += 1

func _on_tourist_avoided(_tourist: Tourist):
	tourists_avoided += 1
	current_streak += 1
	longest_streak = max(longest_streak, current_streak)
