extends Node3D

var _game_over_is_flashing = false

var score: int = 0
@onready var score_label: RichTextLabel = %Score
@onready var game_over_label: RichTextLabel = %GameOver

func _ready() -> void:
	Events.game_over.connect(_on_game_over)
	Events.tourist_avoided.connect(_on_tourist_avoided)
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
	


func _on_tourist_avoided(_tourist: Tourist):
	score += 1
	score_label.text = str(score)
