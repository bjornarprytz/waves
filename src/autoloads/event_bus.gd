class_name EventBus
extends Node2D


# Add signals here for game-wide events. Access through the Events singleton

signal start_game(settings: MainMenu.Settings)
signal game_over(win: bool)
signal tourist_avoided(tourist: Tourist)
signal house_startled(house: Building)
signal tourist_hit(tourist: Tourist)
signal car_movement(change: float)
signal honk_made()
