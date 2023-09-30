extends CharacterBody2D

class_name Player

var dead = false
@export var speed = 400
@export var can_dash = false
@export var dash_speed = 800
@export var minimum_keys_needed = 3
@export var maximum_number_of_keys = 5
#@onready var anim = get_node("AnimationPlayer")
@onready var sprite = get_node("AnimatedSprite2D")

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
	
	if dead:
		return
		
	var input_vector = Vector2.ZERO  # Initialize input_vector to zero vector

	if Input.is_action_pressed("left"):
		input_vector.x -= 1
		#anim.stop()
		sprite.play("run-lateral")
		sprite.set_flip_h(false)
		
	elif Input.is_action_pressed("right"):
		input_vector.x += 1
		#anim.stop()
		sprite.play("run-lateral")
		sprite.set_flip_h(true)
		
	elif Input.is_action_pressed("up"):
		input_vector.y -= 1
		#anim.stop()
		sprite.play("run-up")
		
	elif Input.is_action_pressed("down"):
		input_vector.y += 1

	if input_vector != Vector2.ZERO:
		input_vector = input_vector.normalized()  # Normalize the vector for consistent speed

		movement_direction = input_vector
	else:
		movement_direction = Vector2.ZERO  # No movement if no directional keys are pressed

	if Input.is_action_just_pressed("dash") and can_dash:
		dash()

		

func dash():
	can_dash = false
	dashing = true
	$DashWoosh.play()
	$DashGemHoldingHum.stop()
	timer.start()


func _on_timer_timeout():
	dashing = false
	velocity = movement_direction * speed

func _on_danger_area_body_entered(body):
	if not dashing and body is TileMap:
		# is a danger area
		dead = true
		movement_direction = Vector2.ZERO
		sprite.stop()
		sprite.play("death-lava")
		await sprite.animation_finished
		GameState.refresh_scene()
		print("dead")
		dead = false
		
func pickup_dash_gem(dash_gem: DashGem):
	can_dash = true
	$DashGemAcquired.play()
	$DashGemHoldingHum.play()
	
func pickup_key(key: Key):
	GameState.add_key(key)
	$KeyAcquired.play()
