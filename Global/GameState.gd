extends Node

var total_number_of_keys = 0
var number_of_keys_this_room = 5
var total_number_of_potential_keys;
var number_of_potential_keys_per_room = 5

var total_number_of_sand_deaths = 0
var total_number_of_lava_deaths = 0
var total_number_of_arrow_deaths = 0

var developer_mode = false
var developer_mode_scene: String

var levels = [
	"res://Scenes/Levels/1-1.tscn",
	"res://Scenes/Levels/1-2.tscn",
	"res://Scenes/Levels/1-3.tscn",
	"res://Scenes/Levels/1-4.tscn",
	"res://Scenes/Levels/1-long-boy-level.tscn"
]

var currentLevel;
var level_started = false

var total_time_elapsed_in_milliseconds = 0
var time_elapsed_this_room_in_milliseconds = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	set_time(delta)
	
func set_time(delta):
	if level_started:
		var delta_in_milliseconds = delta * 1000
		total_time_elapsed_in_milliseconds = total_time_elapsed_in_milliseconds + delta_in_milliseconds
		time_elapsed_this_room_in_milliseconds = time_elapsed_this_room_in_milliseconds + delta_in_milliseconds

func set_total_number_of_potential_keys():
	total_number_of_potential_keys = levels.size() * number_of_keys_this_room

# Called when the node enters the scene tree for the first time.
func start_game():
	SceneTransition.toggleHud()
	set_total_number_of_potential_keys()
	if developer_mode:
		currentLevel = developer_mode_scene
	load_next_level()

func load_scene(scene: String):
	SceneTransition.change_scene(scene)


func load_next_level():
	if developer_mode:
		refresh_scene()
	else:
		level_started = false
		
		if levels.size() > 0:
			currentLevel = levels.pop_front()
			load_scene(currentLevel)
			number_of_keys_this_room = 0
		else:
			end_game()

func record_sand_death():
	total_number_of_sand_deaths = total_number_of_sand_deaths + 1
	
func record_lava_death():
	total_number_of_lava_deaths = total_number_of_lava_deaths + 1

func record_arrow_death():
	total_number_of_arrow_deaths = total_number_of_arrow_deaths + 1

func die():
	stop_level()

func get_total_number_of_deaths():
	return total_number_of_sand_deaths + total_number_of_lava_deaths + total_number_of_arrow_deaths

func refresh_scene():
	total_number_of_keys = total_number_of_keys - number_of_keys_this_room
	number_of_keys_this_room = 0
	await load_scene(currentLevel)

func end_game():
	print("Congrats!")
	

func add_key(key: Key):
	total_number_of_keys = total_number_of_keys + key.value
	number_of_keys_this_room = number_of_keys_this_room + key.value

func start_level():
	time_elapsed_this_room_in_milliseconds = 0	
	level_started = true
	
func stop_level():
	level_started = false

func acquired_all_keys():
	return number_of_keys_this_room == number_of_potential_keys_per_room
