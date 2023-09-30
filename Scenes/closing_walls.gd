extends Node2D

var close_speed = 4
var stopped = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if !stopped:
		self.translate(Vector2(0, -10) * delta * close_speed)


func _on_timer_timeout():
	stopped = true
