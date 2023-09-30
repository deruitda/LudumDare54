extends CanvasLayer

func change_scene(scene: String) -> void:
	close_door()
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(scene)
	open_door()
	
func close_door():
	$AnimationPlayer.play('CLOSE')
	$CloseDoorAudio.play()
	$DoorClosedTimer.start()

func open_door():
	$AnimationPlayer.play_backwards('CLOSE')
	$OpenDoorAudio.play()
