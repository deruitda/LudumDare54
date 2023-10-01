extends Area2D

class_name Door

@onready var player = $"../Player"
@onready var number_of_keys_needed = 3
var current_num_keys = 0
var door_unlocked = false

var door_anims = [
	"one",
	"two",
]

func _process(delta):
	print('current num keys')
	print(current_num_keys)
	if !door_unlocked and GameState.number_of_keys_this_room == number_of_keys_needed:
		open_door()
		
	elif GameState.number_of_keys_this_room < number_of_keys_needed && GameState.number_of_keys_this_room > current_num_keys:
		add_key()
		

func _on_body_entered(body):
	if body is Player && door_unlocked:
		GameState.load_next_level()

func open_door():
	$DoorOpeningAudio.play()
	door_unlocked = true
	$AnimatedSprite2D.play("open")
	
func add_key():
	current_num_keys += 1
	var anim = door_anims.pop_front()
	$AnimatedSprite2D.play(anim)
	
