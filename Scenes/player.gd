extends CharacterBody2D

class_name Player

@export var speed = 300

var movement_direction = Vector2.ZERO
var shape_query = PhysicsShapeQueryParameters2D.new()

#onready variables
@onready var collision_shape_2d = $CollisionShape2D

func _ready():
	shape_query.shape = collision_shape_2d.shape
	shape_query.collision_mask = 2

func _physics_process(delta):
	get_input()
	velocity = movement_direction * speed
	move_and_slide()
	
	
func get_input():
	movement_direction = Vector2.ZERO  # Initialize movement_direction to zero vector

	if Input.is_action_pressed("left"):
		movement_direction = Vector2.LEFT
		rotation_degrees = 0
	elif Input.is_action_pressed("right"):
		movement_direction = Vector2.RIGHT
		rotation_degrees = 180
	elif Input.is_action_pressed("up"):
		movement_direction = Vector2.UP
		rotation_degrees = 90
	elif Input.is_action_pressed("down"):
		movement_direction = Vector2.DOWN
		rotation_degrees = 270

