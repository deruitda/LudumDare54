extends Node2D

@export var delay_in_seconds = 0
@export var number_of_seconds_until_closed = 15
enum Direction {
	UP,
	UP_RIGHT,
	RIGHT,
	DOWN_RIGHT,
	DOWN,
	DOWN_LEFT,
	LEFT,
	UP_LEFT
}

@export var direction : Direction = Direction.UP

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
		if delay_in_seconds == 0:
			print('delay in seconds')
			start_movement()
		else:
			print(delay_in_seconds)
			$DelayStartTimer.wait_time = delay_in_seconds
			$DelayStartTimer.start()
	
	if moving:
		
		self.translate(get_vector() * delta * (close_speed_for_one_second / number_of_seconds_until_closed))

func get_vector() -> Vector2:
	var directionSpeeds = {
		Direction.UP: Vector2(0, -10),
		Direction.UP_RIGHT: Vector2(10, -10).normalized(),
		Direction.RIGHT: Vector2(10, 0),
		Direction.DOWN_RIGHT: Vector2(10, 10).normalized(),
		Direction.DOWN: Vector2(0, 10),
		Direction.DOWN_LEFT: Vector2(-10, 10).normalized(),
		Direction.LEFT: Vector2(-10, 0),
		Direction.UP_LEFT: Vector2(-10, -10).normalized()
	}
	return directionSpeeds[direction]

func _on_delay_start_timer_timeout():
	start_movement()
