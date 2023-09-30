extends Area2D

class_name Key

@onready var player = $"../Player"

func _on_body_entered(body):
	if body is Player:
		player.addKey()
		queue_free()
