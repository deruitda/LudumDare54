extends CanvasLayer

@onready var total_number_of_keys_label = $TotalNumberOfKeysLabel
@onready var total_time_label = $TotalTimeLabel
@onready var total_number_of_deaths_label = $TotalNumberOfDeathsLabel
@onready var total_number_of_sand_deaths_label = $TotalNumberOfSandDeathsLabel
@onready var total_number_of_lava_deaths_label = $TotalNumberOfLavaDeathsLabel2
@onready var total_number_of_arrow_deaths_label = $TotalNumberOfArrowDeathsLabel3

func _ready():
	set_total_number_of_keys()
	set_total_number_of_deaths()
	set_total_time_label()

func set_total_number_of_keys():
	total_number_of_keys_label.text = "Keys Acquired: " + str(GameState.total_number_of_keys) + "/" + str(GameState.total_number_of_potential_keys)
	
func set_total_number_of_deaths():
	total_number_of_deaths_label.text = "Total # of Deaths: " + str(GameState.get_total_number_of_deaths())
	total_number_of_arrow_deaths_label.text = "Total # of Arrow Deaths: " + str(GameState.total_number_of_arrow_deaths)
	total_number_of_lava_deaths_label.text = "Total # of Lava Deaths: " + str(GameState.total_number_of_lava_deaths)
	total_number_of_sand_deaths_label.text = "Total # of Sand Deaths: " + str(GameState.total_number_of_sand_deaths)

func get_formatted_time_from_milliseconds(elapsed_in_milliseconds) -> String:
	var minutes = int(elapsed_in_milliseconds / 60000) # Convert milliseconds to minutes
	var seconds = int(fmod(elapsed_in_milliseconds / 1000, 60)) # Convert remaining milliseconds to seconds
	var milliseconds = int(fmod(elapsed_in_milliseconds, 1000)) # Get remaining milliseconds
	
	return "%02d:%02d:%02d" % [minutes, seconds, milliseconds / 10]  # Format the time as 00:00:00 with two decimal places for milliseconds

func set_total_time_label():
	total_time_label.text = "Your Time: " + get_formatted_time_from_milliseconds(GameState.total_time_elapsed_in_milliseconds)

func _on_button_pressed():
	SceneTransition.change_scene("res://Scenes/main_menu.tscn")
