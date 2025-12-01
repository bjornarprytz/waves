class_name TacoStore
extends Node3D

@onready var door: HouseWindow = %Door
@onready var window: HouseWindow = $Window
@onready var window_2: HouseWindow = $Window2


@onready var windows: Array[HouseWindow] = [door, window, window_2]

var target_color: Color = Utility.random_color()
var current_color: Color = Color.WHITE

var _started = false

func _ready() -> void:
	for w in windows:
		w.turn_on_light()
	_started = true;
# Change target color every few seconds

var color_change_timer: float = 0.0
var color_change_interval: float = 1.0

func _process(delta: float) -> void:
	if (!_started):
		return
	current_color = current_color.lerp(target_color, delta * 10.0)
	
	color_change_timer += delta
	if color_change_timer >= color_change_interval:
		color_change_timer = 0.0
		target_color = Utility.random_color()
	
	for w in windows:
		w.change_hue(current_color)


func _on_hit_box_area_entered(area: Area3D) -> void:
	if (area.owner is Tourist):
		var tourist = area.owner as Tourist
		tourist.cleanup()
		tourist.queue_free() # just keep it clear
	if (area.owner is Car):
		Events.game_over.emit(true)
