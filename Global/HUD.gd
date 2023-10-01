extends CanvasLayer

@onready var total_number_of_keys_label = $TotalNumberOfKeysLabel
@onready var total_number_of_potential_keys_label = $TotalNumberOfPotentialKeysLabel
@onready var number_of_keys_this_room_label = $NumberOfKeysThisRoomLabel
@onready var total_time_this_room_label = $TotalTimeThisRoomLabel
@onready var total_time_label = $TotalTimeLabel
@onready var number_of_potential_keys_this_room_label = $NumberOfPotentialKeysThisRoomLabel
@onready var total_number_of_deaths_label = $TotalNumberOfDeathsLabel

func _ready():
	set_total_number_of_potential_keys()
	set_number_of_keys_this_room()

func _process(delta):
	set_total_number_of_keys()
	set_number_of_keys_this_room()
	
func set_total_number_of_keys():
	total_number_of_keys_label.text = GameState.total_number_of_keys
	
func set_total_number_of_potential_keys():
	total_number_of_potential_keys_label.text = GameState.total_number_of_potential_keys
	
func set_number_of_keys_this_room():
	number_of_keys_this_room_label.text = GameState.number_of_keys_this_room

func set_number_of_potential_keys_this_room_label():
	number_of_potential_keys_this_room_label = GameState.number_of_potential_keys_per_room

func set_total_number_of_deaths():
	total_number_of_deaths_label.text = GameState.total_number_of_deaths
