extends Area2D

class_name ArrowTower

@export var direction : Utils.Direction = Utils.Direction.DOWN
@export var fire_rate_per_minute = 30
var speed = 10

func _ready():
	$FireRateTimer.wait_time = (fire_rate_per_minute / 60)
	$FireRateTimer.start()


func fire():
	var arrow_scene = preload("res://Scenes/arrow.tscn")
	var arrow = arrow_scene.instantiate()
	arrow.direction = direction
	arrow.speed = speed
	self.add_child(arrow)



func _on_fire_rate_timer_timeout():
	fire()
	$FireRateTimer.start()	
