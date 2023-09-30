extends Node

var total_number_of_keys = 0
var number_of_keys_this_room = 0

var levels = [
	"res://Scenes/Levels/1-1.tscn",
	"res://Scenes/Levels/1-2.tscn"
]
var currentLevel;
var totalTime = 15.0
var currentLevelTimeRemaining = totalTime

# Called when the node enters the scene tree for the first time.
func _ready():
	load_next_level()

func load_next_level():
	if levels.size() > 0:
		currentLevel = levels.pop_front()
		get_tree().change_scene_to_file(currentLevel)
		number_of_keys_this_room = 0
	else:
		end_game()

func refresh_scene():
	total_number_of_keys = total_number_of_keys - number_of_keys_this_room
	number_of_keys_this_room = 0
	get_tree().change_scene_to_file(currentLevel)

func end_game():
	print("Congrats!")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	currentLevelTimeRemaining -= delta

func add_key(key: Key):
	total_number_of_keys = total_number_of_keys + key.value
	number_of_keys_this_room = number_of_keys_this_room + key.value
