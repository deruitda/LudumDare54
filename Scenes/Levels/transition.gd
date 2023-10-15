extends Node2D

class_name Transition

@export var pre_transition_audio_player_2d: AudioStream
@export var pre_transition_caption = ""

var has_transition = false

func _ready():
	if pre_transition_audio_player_2d != null:
		has_transition = true
	
	var callable = Callable(self, "play_dialogue")
	TransitionDoors.connect("doors_closed", callable)

func play_dialogue():
	TransitionDoors.setTransitionLabel(pre_transition_caption)
	if has_transition and pre_transition_audio_player_2d != null:
		# Create an AudioStreamPlayer2D node to play the audio
		var audio_player = AudioStreamPlayer2D.new()
		audio_player.stream = pre_transition_audio_player_2d
		add_child(audio_player)  # Add the player as a child so it will be automatically deleted when done
		audio_player.play()
