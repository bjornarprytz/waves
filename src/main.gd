extends Node3D

var _game_over_is_flashing = false

var score: int = 0:
	set(value):
		score = value
		score_label.text = str(score)
@onready var score_label: RichTextLabel = %Score
@onready var game_over_label: RichTextLabel = %GameOver

func _ready() -> void:
	Events.game_over.connect(_on_game_over)
	Events.tourist_avoided.connect(_on_tourist_avoided)
	Events.house_startled.connect(_on_house_startled)
	score_label.text = str(score)

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

func _on_house_startled(_house: Building):
	score -= 1

func _on_tourist_avoided(_tourist: Tourist):
	score += 1
