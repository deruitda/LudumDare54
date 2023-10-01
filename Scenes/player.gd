extends CharacterBody2D

class_name Player

@export var default_speed = 800
@export var sand_speed = 400

@export var can_dash = false
@export var dash_speed = 1600
@export var minimum_keys_needed = 3
@export var maximum_number_of_keys = 5
#@onready var anim = get_node("AnimationPlayer")
@onready var sprite = get_node("AnimatedSprite2D")

var dashing = false
var running = false
var in_sand = false
var dashing_while_in_lava = false
var movement_direction = Vector2.ZERO

var shape_query = PhysicsShapeQueryParameters2D.new()
var last_pressed_direction = Vector2.ZERO  # Initialize to zero vector

var dead = false

#onready variables
@onready var collision_shape_2d = $CollisionShape2D
@onready var dash_timer = $DashTimer
@onready var time_in_sand_timer = $TimeInSandTimer


func _ready():
	shape_query.shape = collision_shape_2d.shape
	shape_query.collision_mask = 2

func _physics_process(delta):
	var former_direction = movement_direction
	get_input()
	if GameState.level_started == false:
		return
	
	set_speed()
	
	if former_direction != Vector2.ZERO and movement_direction == Vector2.ZERO:
		stop_running()
	elif former_direction == Vector2.ZERO and movement_direction != Vector2.ZERO:
		start_running()
	
	move_and_slide()

func set_speed():
	var current_speed = get_current_speed()
	velocity = movement_direction * current_speed

func get_current_speed() -> int:
	
	if dashing:
		return dash_speed
	elif in_sand:
		return sand_speed
	else:
		return default_speed

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
	if dashing_while_in_lava and !dead:
		dashing_while_in_lava = false
		experience_lava_death()
	set_speed()
	if movement_direction != Vector2.ZERO:
		footsteps_start()
	
func die(animation_name: String):
	if dead or GameState.level_started == false:
		return
	dead = true
	movement_direction = Vector2.ZERO
	stop_running()
	sprite.stop()
	sprite.play(animation_name)
	await sprite.animation_finished
	await GameState.refresh_scene()
	dead = false

func experience_lava_death():
	$DyingInLavaAudio.play()
	$LavaHissingAudio.play()
	die("death-lava")
	
func experience_sand_death():
	$DyingInSandAudio.play()
	die("death-lava")

func _on_danger_area_body_entered(body):
	if not dashing and body is TileMap and !dead:
		experience_lava_death()
		# is a danger area
	elif dashing and body is TileMap:
		dashing_while_in_lava = true

func _on_danger_area_body_exited(body):
	dashing_while_in_lava = false
	
func pickup_dash_gem(dash_gem: DashGem):
	can_dash = true
	$DashGlow.emitting = true
	$DashGemAcquired.play()
	$DashGemHoldingHum.play()
	
func pickup_key(key: Key):
	GameState.add_key(key)
	$KeyAcquired.play()



func _on_time_in_sand_timer_timeout():
		experience_sand_death()	


func _on_sand_area_area_entered(area):
		if !in_sand and !dead:
			in_sand = true
			$GruntsInSandAudio.play()
			time_in_sand_timer.start()


func _on_sand_area_area_exited(area):
	in_sand = false
	$GruntsInSandAudio.stop()
	time_in_sand_timer.stop()
