extends Node2D

@export var delay_in_seconds = 0
@export var number_of_seconds_until_closed = 15

@export var direction : Utils.Direction = Utils.Direction.UP

var close_speed_for_one_second = 130
var moving = false
var level_started = false

func start_movement():
	if moving == false:
		moving = true
	
func stop_movement():
	moving = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if level_started == false and GameState.level_started == true:
		
		level_started = true
		if delay_in_seconds == 0:
			start_movement()
		else:
			$DelayStartTimer.wait_time = delay_in_seconds
			$DelayStartTimer.start()
	
	if moving:
		
		self.translate(Utils.get_vector(direction) * delta * (close_speed_for_one_second / number_of_seconds_until_closed))


func _on_delay_start_timer_timeout():
	start_movement()
