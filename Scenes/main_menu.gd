extends Node2D

var developer_mode_scene = "res://Scenes/Levels/1-6.tscn"
# var developer_mode_scene = "res://Scenes/prototype_andrew.tscn"
var developer_mode = true
# Called when the node enters the scene tree for the first time.
func _ready():
	if developer_mode:
		GameState.developer_mode = developer_mode
		GameState.developer_mode_scene = developer_mode_scene
		GameState.start_game()
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_pressed():
	GameState.start_game()
