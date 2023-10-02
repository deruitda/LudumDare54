extends Node2D

var starting_scene = "res://Scenes/Levels/1-6.tscn"
var developer_mode = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	get_tree().change_scene_to_file(starting_scene)
	GameState.developer_mode = developer_mode
	GameState.developer_mode_scene = "res://Scenes/Levels/1-6.tscn"
	GameState.start_game()
