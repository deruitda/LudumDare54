extends Area2D

class_name DashGem

@onready var player = $"../Player"

func _on_body_entered(body):
	if body is Player:
		player.pickupDashGem()
		queue_free()
