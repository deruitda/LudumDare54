extends CharacterBody2D

class_name Player

@export var speed = 300
@export var can_dash = false
@export var dash_speed = 1500

var dashing = false
var movement_direction = Vector2.ZERO
var shape_query = PhysicsShapeQueryParameters2D.new()
var last_pressed_direction = Vector2.ZERO  # Initialize to zero vector

#onready variables
@onready var collision_shape_2d = $CollisionShape2D
@onready var timer = $Timer

func _ready():
	shape_query.shape = collision_shape_2d.shape
	shape_query.collision_mask = 2

func _physics_process(delta):
	get_input()
	if dashing:
		velocity = movement_direction * dash_speed
	else:
		velocity = movement_direction * speed
	
	move_and_slide()
	
	

func get_input():
	var input_vector = Vector2.ZERO  # Initialize input_vector to zero vector

	if Input.is_action_pressed("left"):
		input_vector.x -= 1
	if Input.is_action_pressed("right"):
		input_vector.x += 1
	if Input.is_action_pressed("up"):
		input_vector.y -= 1
	if Input.is_action_pressed("down"):
		input_vector.y += 1

	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()  # Normalize the vector for consistent speed

		# Calculate rotation degrees based on input_vector
		rotation_degrees = rad_to_deg(atan2(input_vector.y, input_vector.x))

		movement_direction = input_vector
	else:
		movement_direction = Vector2.ZERO  # No movement if no directional keys are pressed

	if Input.is_action_just_pressed("dash") and can_dash:
		dash()

		

func dash():
	can_dash = false
	dashing = true
	timer.start()


func _on_timer_timeout():
	dashing = false
	velocity = movement_direction * speed
	
func die_and_respawn():
	# Perform death logic, such as hiding the player, showing death animation, etc.
	hide()  # Example: Hide the player
	respawn()  # Call the respawn function after some delay

func respawn():
	# Perform respawn logic, such as resetting player position, showing respawn animation, etc.
	position = Vector2(108, 301)  # Example: Respawn the player at position (100, 100)
	show()  # Show the player again


func _on_danger_area_body_entered(body):
	if not dashing and body is TileMap:
		# is a danger area
		die_and_respawn()
