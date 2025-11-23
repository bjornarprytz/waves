class_name Game
extends Node3D

var _judgement_is_flashing = false

@onready var debug_label: RichTextLabel = %Debug

@onready var camera_pause_anchor: Node3D = %CameraPauseAnchor
@onready var camera_play_anchor: Node3D = %CameraPlayAnchor
@onready var camera: Camera3D = %Camera

@onready var music: AudioStreamPlayer = %Music

@onready var judgement_label: RichTextLabel = %Judgement
@onready var stats_ui: StatsUI = %Stats
@onready var main_menu: CenterContainer = %MainMenu

@onready var ground: Ground = %Ground
@onready var car: Car = %Car

var game_started = false

var lives := 3

var tourists_avoided := 0
var houses_startled := 0
var honks := 0
var tourists_hit := 0
var car_movement := 0.0
var distance_traveled := 0.0

var longest_streak := 0
var current_streak := 0

func restart():
	get_tree().reload_current_scene()

func _process(delta: float) -> void:
	debug_label.text = str(rad_to_deg(ground.current_rotation))

func _ready() -> void:
	Events.game_over.connect(_on_game_over)
	Events.tourist_avoided.connect(_on_tourist_avoided)
	Events.house_startled.connect(_on_house_startled)
	Events.honk_made.connect(_on_honk)
	Events.tourist_hit.connect(_on_tourist_hit)
	Events.car_movement.connect(_on_car_movement)
	Events.distance_traveled.connect(_on_distance_traveled)

func _on_game_over(_result: bool):
	game_started = false

	stats_ui.update(self)
	stats_ui.show()
	#stats_ui.modulate.a = 0.0
	var tween = create_tween()
	# Tween alpha of stats UI or something here
	tween.tween_property(stats_ui, "modulate:a", 1.0, 1.0)

	ground.stop()

	
func _on_honk():
	honks += 1

func _on_tourist_hit(_tourist: Tourist):
	tourists_hit += 1
	current_streak = 0
	lives -= 1

	if lives <= 0:
		Events.game_over.emit(false)
		return

	if (_judgement_is_flashing):
		return
	
	_judgement_is_flashing = true
	for i in range(3):
		judgement_label.show()
		await get_tree().create_timer(0.369).timeout
		judgement_label.hide()
		await get_tree().create_timer(0.369).timeout
	_judgement_is_flashing = false

func _on_house_startled(_house: Building):
	houses_startled += 1

func _on_tourist_avoided(_tourist: Tourist):
	tourists_avoided += 1
	current_streak += 1
	longest_streak = max(longest_streak, current_streak)

func _on_car_movement(change: float) -> void:
	car_movement += abs(change)

func _on_distance_traveled(distance: float) -> void:
	distance_traveled += abs(distance)

func _on_start_game(settings: MainMenu.Settings) -> void:
	if (game_started):
		return
	
	print("Mode: %s" % settings.game_length)
	main_menu.hide()
	if (settings.game_length >= 0):
		ground.place_taco_store(settings.game_length)
	ground.start()
	camera.reparent(camera_play_anchor)
	
	car.process_mode = Node.PROCESS_MODE_INHERIT

	lives = settings.starting_lives
	music.play()
	
	var move_camera_tween = create_tween()
	move_camera_tween.set_parallel()
	move_camera_tween.tween_property(camera, "position", Vector3.ZERO, 1.69)
	move_camera_tween.tween_property(camera, "rotation", Vector3.ZERO, 1.69)
