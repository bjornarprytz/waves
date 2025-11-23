class_name EventBus
extends Node2D


# Add signals here for game-wide events. Access through the Events singleton

signal game_over(win: bool)
signal tourist_avoided(tourist: Tourist)
signal house_startled(house: Building)
signal tourist_hit(tourist: Tourist)
signal car_movement(change: float)
signal distance_traveled(distance: float)
signal honk_made()
