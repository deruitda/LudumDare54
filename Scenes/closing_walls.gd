extends Node2D

@export var delay_in_seconds = 1
@export var number_of_seconds_until_closed = 15
var close_speed_for_one_second = 130
var moving = false
var level_started = false
@onready var sound_fall_audio = $SoundFallAudio


func start_movement():
	print('start movement')
	moving = true
	sound_fall_audio.play()
	
	
func stop_movement():
	moving = false
	sound_fall_audio.stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if level_started == false and GameState.level_started == true:
		level_started = true
		$DelayStartTimer.wait_time = delay_in_seconds
		$DelayStartTimer.start()
	
	if moving:
		self.translate(Vector2(0, -10) * delta * (close_speed_for_one_second / number_of_seconds_until_closed))


func _on_delay_start_timer_timeout():
	start_movement()
