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

var developer_mode = false
var developer_mode_scene: String

var testing_transitions = false

var levels = []

var current_scene;
var current_level_number;
var level_started = false

var on_book_scene = false

var transition_audio_key = {
	1: "res://Assets/Sounds/TransitionDialogue/youve_entered_my_tomb_uninvited.wav",
	2: "res://Assets/Sounds/TransitionDialogue/you_seek_the_power_stored_within.wav",
	3: "res://Assets/Sounds/TransitionDialogue/us_or_you.wav",
	4: "res://Assets/Sounds/TransitionDialogue/or_who_you_will_become.wav",
	5: "res://Assets/Sounds/TransitionDialogue/do_you_think__ive_always_been_this_way.wav",
	6: "res://Assets/Sounds/TransitionDialogue/limited_space.wav"
}

var transition_cc_key = {
	1: "You've entered my tomb uninvited... prepare to die",
	2: "You seek the power stored within.. you will fail",
	3: "You: It’s us or you.. and I know the legends about you",
	4: "You don’t know what you search for.. or who you will become",
	5: "Do you think I've always been this way?",
	6: "There is limited space in the world for those who wish to do good.. you don't know what this book will do to you.."
}


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	set_time(delta)
	
func set_time(delta):
	if level_started and !on_book_scene:
		var delta_in_milliseconds = delta * 1000
		total_time_elapsed_in_milliseconds = total_time_elapsed_in_milliseconds + delta_in_milliseconds
		time_elapsed_this_room_in_milliseconds = time_elapsed_this_room_in_milliseconds + delta_in_milliseconds

func set_total_number_of_potential_keys():
	total_number_of_potential_keys = levels.size() * number_of_keys_this_room

func setup_game():
	set_levels()
	reset_stats()
	
func reset_stats():
	total_number_of_keys = 0
	total_number_of_sand_deaths = 0
	total_number_of_lava_deaths = 0
	total_number_of_arrow_deaths = 0

	total_time_elapsed_in_milliseconds = 0
	time_elapsed_this_room_in_milliseconds = 0
	set_total_number_of_potential_keys()
	on_book_scene = false

func set_levels():
	current_level_number = 0
	levels = [
		"res://Scenes/Levels/1-0.tscn",
	]
# Called when the node enters the scene tree for the first time.
func start_game():
	setup_game()
	if developer_mode:
		current_scene = developer_mode_scene
	load_next_level()

func get_transition_audio():
	if transition_audio_key.has(current_level_number):
		return transition_audio_key[current_level_number]
	return null
func get_transition_cc():
	if transition_cc_key.has(current_level_number):
		return transition_cc_key[current_level_number]
	return null

func load_scene(scene: String, with_transition = true):
	if with_transition:
		var transition_audio = get_transition_audio()
		var transition_cc = get_transition_cc()
		SceneTransition.change_scene(scene, transition_audio, transition_cc)
	else:
		SceneTransition.change_scene(scene)

func test_transitions():
	setup_game()	
	testing_transitions = true
	load_next_level()

func load_next_level():
	if developer_mode:
		refresh_scene()
	else:
		level_started = false
		
		if levels.size() > 0:
			current_scene = levels.pop_front()
			load_scene(current_scene)
			number_of_keys_this_room = 0
		else:
			go_to_book_scene()
	
	current_level_number = current_level_number + 1

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
	await load_scene(current_scene, false)

func go_to_book_scene():
	var book_scene_audio = "res://Assets/Sounds/TransitionDialogue/im_not_you.wav"
	var book_scene_cc = "You: I will be different.. I have to.. I'm not you!"
	SceneTransition.change_to_menu_scene("res://Scenes/Levels/book_scene.tscn", book_scene_audio, book_scene_cc)
	on_book_scene = true
	level_started = true

func end_game():
	stop_level()
	SceneTransition.change_to_menu_scene("res://Scenes/Levels/final_scene.tscn")

func add_key(key: Key):
	total_number_of_keys = total_number_of_keys + key.value
	number_of_keys_this_room = number_of_keys_this_room + key.value
	print(number_of_keys_this_room)

func start_level():
	if testing_transitions:
		load_next_level()
	else:
		time_elapsed_this_room_in_milliseconds = 0	
		level_started = true
	
func stop_level():
	level_started = false

func acquired_all_keys():
	return number_of_keys_this_room == number_of_potential_keys_per_room

func book_acquired():
	SceneTransition.abrupt_end()
