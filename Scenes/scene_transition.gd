extends CanvasLayer
var game_is_started = false
var changing_to_menu_scene = false

func setHudVisibility(val: bool):
	$HUD.visible = val

func change_to_menu_scene(scene: String) -> void:
	GameState.stop_level()
	changing_to_menu_scene = true
	change_scene(scene)
	

func change_scene(scene: String) -> void:
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
	if changing_to_menu_scene:
		changing_to_menu_scene = false
		setHudVisibility(false)
	else:
		GameState.start_level()
		$GrowingAmbientSandAudio.play()
		setHudVisibility(true)

func _on_door_closed_timer_timeout():
	$DoorClosedTimer.stop()
	open_door()
	
