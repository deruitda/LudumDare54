extends Area2D

class_name ArrowTower

@export var direction : Utils.Direction = Utils.Direction.DOWN
@export var fire_rate_per_minute = 30.0
@export var speed = 10

func _ready():
	start_timer()


func fire():
	var arrow_scene = preload("res://Scenes/arrow.tscn")
	var arrow = arrow_scene.instantiate()
	arrow.direction = direction
	arrow.speed = speed
	self.add_child(arrow)
	$ArrowShotAudio.play()

func start_timer():
	$FireRateTimer.wait_time = (60.0 / fire_rate_per_minute)
	$FireRateTimer.start()

func _on_fire_rate_timer_timeout():
	fire()
	start_timer()	
