extends Node2D

var close_speed = 4
var moving = false
var level_started = false
@onready var sound_fall_audio = $SoundFallAudio
# Called when the node enters the scene tree for the first time.
func _ready():
	start_movement()

func start_movement():
	moving = true
	sound_fall_audio.play()
	
	
func stop_movement():
	moving = false
	sound_fall_audio.stop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if level_started == false and GameState.level_started == true:
		level_started = true
		start_movement()
	
	if moving:
		self.translate(Vector2(0, -10) * delta * close_speed)


func _on_timer_timeout():
	moving = false
