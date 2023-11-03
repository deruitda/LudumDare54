extends Node2D

class_name Level

@export var number_of_keys = 5
@export var has_sand = true
@export var transition: Transition
@export var next_level: Level

var current_level_number = 0
var current_world_number = 0
var is_the_first_time_playing_level = false

var has_received_input = false
var door_has_opened = false
var level_has_started = false

var player_has_died = false

func _ready():
	set_current_level_number()

	if current_level_number != GameState.current_level_number or current_world_number != GameState.current_world_number:
		GameState.set_current_level(current_level_number, current_world_number)
		transition.play_dialogue()
	
	TransitionDoors.connect("doors_opened", Callable(self, "on_transition_doors_opened"))
	TransitionDoors.connect("doors_closed", Callable(self, "on_transition_doors_closed"))


func _process(delta):
	register_input()
	if door_has_opened and has_received_input and !level_has_started:
		GameState.level_has_started = true

func register_input():
	if !has_received_input and Input.is_action_pressed("up") or Input.is_action_pressed("down") or Input.is_action_pressed("left") or Input.is_action_pressed("right"):
		has_received_input = true

func on_transition_doors_opened():
	door_has_opened = true
	
func set_current_level_number():
	var scene_path = get_tree().current_scene.scene_file_path
	var parts = scene_path.get_basename().split("-") # Split the scene name by "-"
	
	if parts.size() == 2:
		current_world_number = int(parts[0])
		var level_part = parts[1].split("-")
		if level_part.size() == 2:
			current_level_number = int(level_part[0])
		else:
			print("Invalid level number format")
	else:
		print("Invalid scene name format")

func _on_transition_dialogue_finished():
	TransitionDoors.open_doors()


func _on_player_death_animation_finished():
	GameState.level_has_started = false

func _on_player_died():
	player_has_died = true
	TransitionDoors.close_door()

func on_transition_doors_closed():
	if player_has_died:
		get_tree().reload_current_scene()
	else:
		get_tree().
