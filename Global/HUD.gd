extends CanvasLayer

@onready var total_number_of_keys_label = $TotalNumberOfKeys/TotalNumberOfKeysLabel
@onready var total_number_of_potential_keys_label = $TotalNumberOfKeys/TotalNumberOfPotentialKeysLabel
@onready var number_of_keys_this_room_label = $NumberOfKeysThisRoom/NumberOfKeysThisRoomLabel
@onready var total_time_this_room_label = $TotalTimeThisRoomLabel
@onready var total_time_label = $TotalTimeLabel
@onready var number_of_potential_keys_this_room_label = $NumberOfKeysThisRoom/NumberOfPotentialKeysThisRoomLabel
@onready var total_number_of_deaths_label = $TotalNumberOfDeathsLabel

func _process(delta):
	set_total_number_of_keys()
	set_number_of_keys_this_room()
	set_total_number_of_potential_keys()
	set_number_of_keys_this_room()
	set_total_number_of_deaths()
	
func set_total_number_of_keys():
	total_number_of_keys_label.text = str(GameState.total_number_of_keys)
	
func set_total_number_of_potential_keys():
	total_number_of_potential_keys_label.text = str(GameState.total_number_of_potential_keys)
	
func set_number_of_keys_this_room():
	number_of_keys_this_room_label.text = str(GameState.number_of_keys_this_room)

func set_number_of_potential_keys_this_room_label():
	number_of_potential_keys_this_room_label = str(GameState.number_of_potential_keys_per_room)

func set_total_number_of_deaths():
	total_number_of_deaths_label.text = str(GameState.get_total_number_of_deaths())
