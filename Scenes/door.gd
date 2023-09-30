extends Area2D

class_name Door

@onready var sprite_2d = $Sprite2D
@onready var player = $"../Player"
@onready var number_of_keys_needed = 3
var door_unlocked = false

func _process(delta):
	if !door_unlocked and GameState.number_of_keys_this_room == number_of_keys_needed:
		open_door()

func _on_body_entered(body):
	if body is Player && door_unlocked:
		GameState.load_next_level()

func open_door():
	$DoorOpeningAudio.play()
	door_unlocked = true
	sprite_2d.texture = preload("res://Assets/door-open.png")
	
