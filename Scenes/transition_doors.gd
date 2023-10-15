extends CanvasLayer

var game_is_started = false
var changing_to_menu_scene = false
@onready var transition_closed_caption_label = $DoorRect/TransitionClosedCaptionLabel

signal doors_closing
signal doors_closed

signal doors_opening
signal doors_opened

func setHudVisibility(val: bool):
	$HUD.visible = val

func setTransitionLabel(label: String):
	transition_closed_caption_label.text = label

func change_scene(scene: String) -> void:
	close_door()

func close_door():
	print("doors closing")
	TransitionDoors.emit_signal("doors_closing")
	$AnimationPlayer.play('CLOSE')
	$CloseDoorAudio.play()
	
	await $AnimationPlayer.animation_finished
	TransitionDoors.emit_signal("doors_closed")
	

func open_door():
	TransitionDoors.emit_signal("doors_opening")
	$AnimationPlayer.play_backwards('CLOSE')
	$OpenDoorAudio.play()	
	await $AnimationPlayer.animation_finished
	TransitionDoors.emit_signal("doors_opened")

func _on_door_closed_timer_timeout():
	transition_closed_caption_label.text = ""
	$DoorClosedTimer.stop()
	print("emitting doors_closed")
	TransitionDoors.emit_signal("doors_closed")

func abrupt_end():
	TransitionDoors.emit_signal("doors_closing")
	$AnimationPlayer.play('ABRUPT_END')
	$AbruptDoorCloseAudio.play()
	await $AnimationPlayer.animation_finished
	TransitionDoors.emit_signal("doors_closed")
	
	
