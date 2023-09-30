extends Node

var currentLevel;
var totalTime = 15.0
var currentLevelTimeRemaining = totalTime

# Called when the node enters the scene tree for the first time.
func _ready():
	currentLevel = "1-1"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	currentLevelTimeRemaining -= delta
	print(currentLevelTimeRemaining)

func goto_next_level():
	pass
