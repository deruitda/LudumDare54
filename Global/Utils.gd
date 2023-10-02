extends Node

enum Direction {
	UP,
	UP_RIGHT,
	RIGHT,
	DOWN_RIGHT,
	DOWN,
	DOWN_LEFT,
	LEFT,
	UP_LEFT
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Define the speed for each direction
var directionSpeeds = {
	Direction.UP: Vector2(0, -1),
	Direction.UP_RIGHT: Vector2(1, -1).normalized(),
	Direction.RIGHT: Vector2(1, 0),
	Direction.DOWN_RIGHT: Vector2(1, 1).normalized(),
	Direction.DOWN: Vector2(0, 1),
	Direction.DOWN_LEFT: Vector2(-1, 1).normalized(),
	Direction.LEFT: Vector2(-1, 0),
	Direction.UP_LEFT: Vector2(-1, -1).normalized()
}

func get_vector(direction: Direction) -> Vector2:
	return directionSpeeds[direction] * 10
	
