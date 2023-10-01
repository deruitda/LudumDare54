extends Node

@export var sandbox = true
#@export var sandbox_scene = "res://Scenes/prototype_andrew.tscn"
@export var sandbox_scene = "res://Scenes/base_level.tscn"

var total_number_of_keys = 0
var number_of_keys_this_room = 0

var levels = [
	"res://Scenes/Levels/1-1.tscn",
	"res://Scenes/Levels/1-2.tscn"
]

var currentLevel;
var totalTime = 15.0
var currentLevelTimeRemaining = totalTime
var level_started = false

# Called when the node enters the scene tree for the first time.
func _ready():
	load_next_level()

func load_scene(scene: String):
	SceneTransition.change_scene(scene)

func load_next_level():
	if sandbox:
		currentLevel = sandbox_scene
		load_scene(sandbox_scene)
	else:
		if levels.size() > 0:
			currentLevel = levels.pop_front()
			load_scene(currentLevel)
			number_of_keys_this_room = 0
		else:
			end_game()

func refresh_scene():
	total_number_of_keys = total_number_of_keys - number_of_keys_this_room
	number_of_keys_this_room = 0
	load_scene(currentLevel)

func end_game():
	print("Congrats!")
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	currentLevelTimeRemaining -= delta

func add_key(key: Key):
	total_number_of_keys = total_number_of_keys + key.value
	number_of_keys_this_room = number_of_keys_this_room + key.value

func start_level():
	level_started = true
	
func stop_level():
	level_started = false
