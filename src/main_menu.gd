class_name MainMenu
extends Control

class Settings:
	## Between 
	var game_length: int
	var starting_lives: int = 3
	
	func _init(mode: String = "Endless", lives: int = 3) -> void:
		# NOTE: car starts at 180 degrees
		match (mode):
			"Endless":
				game_length = -1
			"Long":
				game_length = 120
			"Short":
				game_length = 300
	
		self.starting_lives = lives

var modes = ["Short", "Long", "Endless"]

@onready var mode_left: Button = %ModeLeft
@onready var mode_right: Button = %ModeRight
@onready var mode_name: RichTextLabel = %ModeName

var current_mode_idx: int = 0

func _on_start_button_pressed() -> void:
	var current_mode = modes[current_mode_idx]
	
	Events.start_game.emit(Settings.new(current_mode))


func _input(event: InputEvent) -> void:
	if (event is InputEventKey and event.pressed):
		if (event.keycode == Key.KEY_LEFT):
			_on_mode_left_pressed()
		elif (event.keycode == Key.KEY_RIGHT):
			_on_mode_right_pressed()
		elif (event.keycode == Key.KEY_ENTER or event.keycode == Key.KEY_KP_ENTER):
			_on_start_button_pressed()


func _on_mode_left_pressed() -> void:
	current_mode_idx = (current_mode_idx - 1) % modes.size()
	_update_mode_name()

func _on_mode_right_pressed() -> void:
	current_mode_idx = (current_mode_idx + 1) % modes.size()
	_update_mode_name()

func _update_mode_name() -> void:
	mode_name.clear()
	mode_name.append_text(modes[current_mode_idx])
