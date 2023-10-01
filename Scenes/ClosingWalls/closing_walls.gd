extends Node2D

@export var delay_in_seconds = 1
@export var number_of_seconds_until_closed = 15
@export var direction = Vector2(0, -10)
var close_speed_for_one_second = 130
var moving = false
var level_started = false
@onready var sand_wall_audio = $SandWallAudio


func start_movement():
	print('start movement')
	moving = true
	sand_wall_audio.play()
	
	
func stop_movement():
	moving = false
	sand_wall_audio.stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if level_started == false and GameState.level_started == true:
		level_started = true
		$DelayStartTimer.wait_time = delay_in_seconds
		$DelayStartTimer.start()
	
	if moving:
		self.translate(direction * delta * (close_speed_for_one_second / number_of_seconds_until_closed))


func _on_delay_start_timer_timeout():
	start_movement()
