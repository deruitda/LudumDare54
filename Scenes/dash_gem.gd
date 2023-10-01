extends Area2D

class_name DashGem

@onready var player = $"../Player"

func _on_body_entered(body):
	if body is Player and player.has_dash_gem == false:
		player.pickup_dash_gem(self)
		queue_free()

