class_name Cooldown
extends ProgressBar

var progress_tween: Tween
@onready var message: RichTextLabel = %Message

func _ready() -> void:
	Events.honk_attempted.connect(_on_honk_attempted)

func _on_honk_attempted(timer: Timer):
	if progress_tween != null || timer == null || timer.wait_time <= 0.0:
		return
	
	self.show()

	value = max_value - (timer.time_left / timer.wait_time * max_value)

	progress_tween = create_tween().set_parallel()
	progress_tween.tween_property(self, "value", max_value, timer.time_left)
	# Flash the message
	progress_tween.tween_method(_flash_message, timer.time_left, 0.0, timer.time_left)
	
	await progress_tween.finished
	progress_tween = null
	self.hide()

func _flash_message(t: float):
	message.modulate.a = pingpong(t * 4.0, 1.0)
