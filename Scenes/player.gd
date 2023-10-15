extends CharacterBody2D

class_name Player

@export var default_speed = 800
@export var sand_speed = 400

@export var in_book_scene = false

var book_speed = 100
var book_sound_position = 0

@export var has_dash_gem = false
@export var dash_speed = 1600
@export var minimum_keys_needed = 3
@export var maximum_number_of_keys = 5
#@onready var anim = get_nodde("AnimationPlayer")
@onready var sprite = get_node("AnimatedSprite2D")

var running = false
var dashing = 0
var in_sand = 0
var dashing_while_in_lava = false
var movement_direction = Vector2.ZERO

var shape_query = PhysicsShapeQueryParameters2D.new()
var last_pressed_direction = Vector2.ZERO  # Initialize to zero vector

var dead = false

#onready variables
@onready var collision_shape_2d = $CollisionShape2D
@onready var dash_timer = $DashTimer
@onready var time_in_sand_timer = $TimeInSandTimer

signal died
signal death_animation_finished

func _ready():
	shape_query.shape = collision_shape_2d.shape
	shape_query.collision_mask = 2

func _physics_process(delta):
	var former_direction = movement_direction
	get_input()
	if GameState.level_started == false:
		stop_running()
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
	
	if is_dashing():
		return dash_speed
	elif is_in_sand():
		return sand_speed
	elif in_book_scene:
		return book_speed
	else:
		return default_speed

func is_in_sand():
	return in_sand > 0

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

	if Input.is_action_just_pressed("dash") and has_dash_gem:
		dash()

func start_running():
	running = true
	footsteps_start()
	
func stop_running():
	running = false
	footsteps_stop()

func footsteps_start():
	if in_book_scene:
		$SlowWalkAudio.play(book_sound_position)
	else:
		$FootstepsAudio.play()

func footsteps_stop():
	if in_book_scene:
		book_sound_position = $SlowWalkAudio.get_playback_position( )
		$SlowWalkAudio.stop()
	else:
		$FootstepsAudio.stop()

func is_dashing():
	return dashing > 0

func dash():
	has_dash_gem = false
	dashing = dashing + 1
	$DashGlow.visible = false
	
	$DashZoom.process_material.direction.x = - movement_direction.x
	$DashZoom.process_material.direction.y = - movement_direction.y

	$DashZoom.emitting = true
	
	footsteps_stop()
	$DashWoosh.play()
	$DashGemHoldingFadeOut.play()	
	$DashGemHoldingHum.stop()
	dash_timer.start()

func _on_dash_timer_timeout():
	dashing = dashing - 1
	if !is_dashing():
		dash_timer.stop()
		if dashing_while_in_lava and !dead:
			dashing_while_in_lava = false
			$LavaDeathTimer.start()
		set_speed()
		if movement_direction != Vector2.ZERO:
			footsteps_start()
	
func die(animation_name: String):
	if dead:
		return
	dead = true
	emit_signal("died")
	movement_direction = Vector2.ZERO

	stop_running()
	sprite.stop()

	sprite.play(animation_name)
	await sprite.animation_finished

	emit_signal("death_animation_finished")

func experience_lava_death():
	if GameState.level_started:
		$DyingInLavaAudio.play()
		$LavaHissingAudio.play()
		GameState.record_lava_death()
		die("death-lava")
	
func experience_sand_death():
	if GameState.level_started:
		$DyingInSandAudio.play()
		GameState.record_sand_death()
		die("death-sand")

func experience_arrow_death():
	if GameState.level_started:
		$ArrowLandingAudio.play()
		$DyingByArrowAudio.play()
		GameState.record_arrow_death()
		die("death-arrow")

func _on_danger_area_body_entered(body):
	if not dashing and body is TileMap and !dead:
		$LavaDeathTimer.start()
		# is a danger area
	elif dashing and body is TileMap:
		dashing_while_in_lava = true

func _on_danger_area_body_exited(body):
	dashing_while_in_lava = false
	$LavaDeathTimer.stop()
	
	
func pickup_dash_gem(dash_gem: DashGem):
	has_dash_gem = true
	$DashGlow.visible = true
	$DashGemAcquiredSound.play()
	$DashGemAcquiredSound2.play()
	$DashGemHoldingHum.play()
	
func pickup_key(key: Key):
	GameState.add_key(key)
	if GameState.acquired_all_keys():
		$AcquiredAllKeysAudio.play()
	else:
		$KeyAcquired.play()

func _on_time_in_sand_timer_timeout():
	
	if !dead:
		experience_sand_death()	

func _on_sand_area_area_entered(area):
	if !dead && GameState.level_started:
		if !is_in_sand():
			$GruntsInSandAudio.play()
			time_in_sand_timer.start()
		in_sand = in_sand + 1

func _on_sand_area_area_exited(area):
	in_sand = in_sand - 1
	if !is_in_sand() || GameState.level_started == false:
		$GruntsInSandAudio.stop()
		time_in_sand_timer.stop()


func _on_arrow_area_area_entered(area):
	if !dead and !is_dashing():
		experience_arrow_death()
		area.queue_free()

func _on_book_area_area_entered(area):
	$BookAcquiringAudio.play()
	$AbruptEndTimer.start()

func _on_abrupt_end_timer_timeout():
	GameState.book_acquired()
	


func _on_lava_death_timer_timeout():
	experience_lava_death()
