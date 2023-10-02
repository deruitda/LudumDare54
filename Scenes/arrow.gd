extends Area2D

class_name Arrow

var direction : Utils.Direction = Utils.Direction.DOWN
var speed : int

func _process(delta):
	var vector = Utils.get_vector(direction)
	position = position + (vector * (speed * delta))


func _on_area_entered(area):
	print('kill')
