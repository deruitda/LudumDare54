extends Node

var currentLevel;
var total_number_of_keys = 0
var number_of_keys_this_room = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	currentLevel = "1-1"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func goto_next_level():
	pass

func add_key(key: Key):
	total_number_of_keys = total_number_of_keys + key.value
	number_of_keys_this_room = number_of_keys_this_room + key.value
