extends Node2D

class_name Transition

@export var pre_transition_audio_player_2d: AudioStream
@export var pre_transition_caption = ""

var has_transition = false

func _ready():
	if pre_transition_audio_player_2d != null:
		has_transition = true
