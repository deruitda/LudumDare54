extends CanvasLayer
var game_is_started = false
var changing_to_menu_scene = false
@onready var transition_closed_caption_label = $DoorRect/TransitionClosedCaptionLabel
func setHudVisibility(val: bool):
	$HUD.visible = val

func change_to_menu_scene(scene: String, transition_audio = null, transition_cc = null) -> void:
	GameState.stop_level()
	changing_to_menu_scene = true
	change_scene(scene, transition_audio, transition_cc)
	

func change_scene(scene: String, transition_audio = null, transition_cc = null) -> void:
	GameState.stop_level()
	close_door()
	await $AnimationPlayer.animation_finished
	$GrowingAmbientSandAudio.stop()
	get_tree().change_scene_to_file(scene)	
	if transition_audio is String:
		$AdditionalTransitionAudio.stream = load(transition_audio)
		$AdditionalTransitionAudio.play()
		if transition_cc:
			transition_closed_caption_label.text = transition_cc
		await $AdditionalTransitionAudio.finished
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
	transition_closed_caption_label.text = ""
	$DoorClosedTimer.stop()
	open_door()

func abrupt_end():
	GameState.level_started = false
	$AnimationPlayer.play('ABRUPT_END')
	$AbruptDoorCloseAudio.play()
	await $AnimationPlayer.animation_finished
	GameState.level_started = false
	$GrowingAmbientSandAudio.stop()
	$FinalSceneTransition.start()

func _on_final_scene_transition_timeout():
	$FinalSceneTransition.stop()
	get_tree().change_scene_to_file("res://Scenes/Levels/final_scene.tscn")
	$".".visible = false
	$AnimationPlayer.play_backwards('CLOSE')
	await $AnimationPlayer.animation_finished
	$".".visible = true
	
	
