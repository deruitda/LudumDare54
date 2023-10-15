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
	await pre_transition_audio_player_2d.play()
