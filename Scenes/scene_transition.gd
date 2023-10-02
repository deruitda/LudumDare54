extends CanvasLayer
var game_is_started = false

func toggleHud():
	$HUD.visible = !$HUD.visible

func change_to_menu_scene(scene: String) -> void:
	game_is_started = false
	

func change_scene(scene: String) -> void:
	if game_is_started == false:
		game_is_started = true
		get_tree().change_scene_to_file(scene)
		open_door()
	else:
		GameState.stop_level()
		close_door()
		await $AnimationPlayer.animation_finished
		$GrowingAmbientSandAudio.stop()
		get_tree().change_scene_to_file(scene)
		$DoorClosedTimer.start()


func close_door():
	$AnimationPlayer.play('CLOSE')
	$CloseDoorAudio.play()

func open_door():
	$AnimationPlayer.play_backwards('CLOSE')
	$OpenDoorAudio.play()	
	await $AnimationPlayer.animation_finished
	GameState.start_level()
	$GrowingAmbientSandAudio.play()


func _on_door_closed_timer_timeout():
	$DoorClosedTimer.stop()
	open_door()
	
