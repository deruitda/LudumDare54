extends Node
var number_of_potential_keys_per_room = 5

var number_of_keys_this_room = 5

var total_number_of_potential_keys;

var total_number_of_keys = 0
var total_number_of_sand_deaths = 0
var total_number_of_lava_deaths = 0
var total_number_of_arrow_deaths = 0

var total_time_elapsed_in_milliseconds = 0
var time_elapsed_this_room_in_milliseconds = 0

var current_level_number = 0;
var current_world_number = 0;

var level_started = false
var starting_game = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	set_time(delta)
	
func set_time(delta):
	if level_started:
		var delta_in_milliseconds = delta * 1000
		total_time_elapsed_in_milliseconds = total_time_elapsed_in_milliseconds + delta_in_milliseconds
		time_elapsed_this_room_in_milliseconds = time_elapsed_this_room_in_milliseconds + delta_in_milliseconds

func set_current_level(current_level_number: int, current_world_number: int):
	self.current_level_number = current_level_number
	self.current_world_number = current_world_number

func start_level():
	level_started = true

func stop_level():
	level_started = false

func setup_game():
	reset_stats()
	
func reset_stats():
	total_number_of_keys = 0
	total_number_of_sand_deaths = 0
	total_number_of_lava_deaths = 0
	total_number_of_arrow_deaths = 0

	total_time_elapsed_in_milliseconds = 0
	time_elapsed_this_room_in_milliseconds = 0
	
	starting_game = true

# Called when the node enters the scene tree for the first time.
func start_game():
	starting_game = true
	
	setup_game()
	load_first_level()
	
func load_first_level():
	TransitionDoors.connect("doors_closed", Callable(self, "on_transition_doors_closed"))
	TransitionDoors.close_door()
	
func on_transition_doors_closed():
	print("game state on_transition_doors_closed")
	if starting_game:
		starting_game = false
		var first_level = "res://Scenes/Levels/1-0.tscn"
		get_tree().change_scene_to_file(first_level)

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


func add_key(key: Key):
	total_number_of_keys = total_number_of_keys + key.value
	number_of_keys_this_room = number_of_keys_this_room + key.value
	print(number_of_keys_this_room)

func acquired_all_keys():
	return number_of_keys_this_room == number_of_potential_keys_per_room

