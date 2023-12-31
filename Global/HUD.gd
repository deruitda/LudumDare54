extends CanvasLayer

@onready var total_number_of_keys_label = $TotalNumberOfKeysLabel
@onready var total_time_this_room_label = $TotalTimeThisRoomLabel
@onready var total_time_label = $TotalTimeLabel
@onready var total_number_of_deaths_label = $TotalNumberOfDeathsLabel
@onready var key_legend_sprite = $KeyLegendSprite

var key_animation_textures = {
	0: preload("res://Assets/image/ui/keys/key-ui-1.png"),
	1: preload("res://Assets/image/ui/keys/key-ui-0.png"),
	2: preload("res://Assets/image/ui/keys/key-ui-2.png"),
	3: preload("res://Assets/image/ui/keys/key-ui-3.png"),
	4: preload("res://Assets/image/ui/keys/key-ui-4.png"),
	5: preload("res://Assets/image/ui/keys/key-ui-5.png")
}

func _process(delta):
	if Input.is_action_just_pressed("pause"):
		if get_tree().paused:
			unpause_game()
		else:
			pause_game()
	set_total_number_of_keys()
	set_number_of_keys_this_room()
	set_total_number_of_deaths()
	set_total_time_label()
	set_total_time_this_room_label()

func pause_game():
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	get_tree().paused = true
	$Button.visible = true
	
func unpause_game():
	get_tree().paused = false
	$Button.visible = false
	process_mode = Node.PROCESS_MODE_INHERIT
	

func set_total_number_of_keys():
	total_number_of_keys_label.text = str(GameState.total_number_of_keys) + "/" + str(GameState.total_number_of_potential_keys)
	
func set_number_of_keys_this_room():
	
	# Get the path dynamically (assuming 'key_animation_sprites' is an array of file paths)
	# Assuming GameState.number_of_keys_this_room contains the appropriate key number
	var key_number = GameState.number_of_keys_this_room
	
	# Check if the key number is valid
	if key_animation_textures.has(key_number):
		# Set the texture using the preloaded texture from the dictionary
		key_legend_sprite.texture = key_animation_textures[key_number]

func set_total_number_of_deaths():
	total_number_of_deaths_label.text = str(GameState.get_total_number_of_deaths())

func get_formatted_time_from_milliseconds(elapsed_in_milliseconds) -> String:
	var minutes = int(elapsed_in_milliseconds / 60000) # Convert milliseconds to minutes
	var seconds = int(fmod(elapsed_in_milliseconds / 1000, 60)) # Convert remaining milliseconds to seconds
	var milliseconds = int(fmod(elapsed_in_milliseconds, 1000)) # Get remaining milliseconds
	
	return "%02d:%02d:%02d" % [minutes, seconds, milliseconds / 10]  # Format the time as 00:00:00 with two decimal places for milliseconds


func set_total_time_this_room_label():
	total_time_label.text = get_formatted_time_from_milliseconds(GameState.total_time_elapsed_in_milliseconds)

func set_total_time_label():
	total_time_this_room_label.text = get_formatted_time_from_milliseconds(GameState.time_elapsed_this_room_in_milliseconds)



func _on_button_pressed():
	unpause_game()
