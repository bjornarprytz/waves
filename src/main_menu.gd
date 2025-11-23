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

signal start_game(settings: Settings)

@onready var game_mode_button_group: ButtonGroup = %Short.button_group

func _input(event: InputEvent) -> void:
    if (event.is_action_pressed("start")):
        _on_start_button_pressed()

func _on_start_button_pressed() -> void:
    var current_mode = game_mode_button_group.get_pressed_button()
    var mode_name = "Endless"
    if (current_mode):
        mode_name = current_mode.name
    
    start_game.emit(Settings.new(mode_name))
