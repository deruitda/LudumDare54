extends CharacterBody2D

class_name Player

@export var speed = 400
@export var can_dash = false
@export var dash_speed = 800
@export var minimum_keys_needed = 3
@export var maximum_number_of_keys = 5
#@onready var anim = get_node("AnimationPlayer")
@onready var sprite = get_node("AnimatedSprite2D")

var dashing = false
var running = false
var movement_direction = Vector2.ZERO

var shape_query = PhysicsShapeQueryParameters2D.new()
var last_pressed_direction = Vector2.ZERO  # Initialize to zero vector

var dead = false

#onready variables
@onready var collision_shape_2d = $CollisionShape2D
@onready var dash_timer = $DashTimer

func _ready():
	shape_query.shape = collision_shape_2d.shape
	shape_query.collision_mask = 2

func _physics_process(delta):
	var former_direction = movement_direction
	get_input()
	if GameState.level_started == false:
		return
	if dashing:
		velocity = movement_direction * dash_speed
	else:
		velocity = movement_direction * speed
	
	
	if former_direction != Vector2.ZERO and movement_direction == Vector2.ZERO:
		stop_running()
	elif former_direction == Vector2.ZERO and movement_direction != Vector2.ZERO:
		start_running()
	
	move_and_slide()
	
	

func get_input():
	
	if dead:
		return
		
	var input_vector = Vector2.ZERO  # Initialize input_vector to zero vector

	if Input.is_action_pressed("left"):
		input_vector.x -= 1
		sprite.play("run-lateral")
		sprite.set_flip_h(false)
		
	if Input.is_action_pressed("right"):
		input_vector.x += 1
		sprite.play("run-lateral")
		sprite.set_flip_h(true)
		
	if Input.is_action_pressed("up"):
		input_vector.y -= 1
		sprite.play("run-up")
		
	if Input.is_action_pressed("down"):
		input_vector.y += 1
		sprite.play("run-lateral")

	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()  # Normalize the vector for consistent speed

		movement_direction = input_vector
	else:
		movement_direction = Vector2.ZERO  # No movement if no directional keys are pressed

	if Input.is_action_just_pressed("dash") and can_dash:
		dash()

func start_running():
	running = true
	footsteps_start()
	
func stop_running():
	running = false
	footsteps_stop()

func footsteps_start():
	$FootstepsAudio.play()

func footsteps_stop():
	$FootstepsAudio.stop()

func dash():
	can_dash = false
	dashing = true
	$DashGlow.emitting = false
	footsteps_stop()
	$DashWoosh.play()
	$DashGemHoldingHum.stop()
	dash_timer.start()



func _on_dash_timer_timeout():
	dashing = false
	velocity = movement_direction * speed
	if movement_direction != Vector2.ZERO:
		footsteps_start()
	
func die():
	dead = true
	movement_direction = Vector2.ZERO
	stop_running()
	sprite.stop()
	sprite.play("death-lava")
	await sprite.animation_finished
	GameState.refresh_scene()
	dead = false

func _on_danger_area_body_entered(body):
	if not dashing and body is TileMap:
		# is a danger area
		die()

func pickup_dash_gem(dash_gem: DashGem):
	can_dash = true
	$DashGlow.emitting = true
	$DashGemAcquired.play()
	$DashGemHoldingHum.play()
	
func pickup_key(key: Key):
	GameState.add_key(key)
	$KeyAcquired.play()

