extends Area2D

class_name Key

@onready var player = $"../Player"
@export var value = 1

func _on_body_entered(body):
	if body is Player:
		player.pickup_key(self)
		queue_free()
