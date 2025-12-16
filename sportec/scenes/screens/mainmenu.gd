extends Control

func _ready() -> void:
	MusicManager.play_music("menu")

func playPressed() -> void:
	var button = $Background/PlayButton
	button.modulate.a = 0.5
	await get_tree().create_timer(0.1).timeout
	button.modulate.a = 1.0
	PlayerSound.playSound(PlayerSound.Sound.SELECT)
	get_tree().change_scene_to_file("res://scenes/screens/team_selector.tscn")

func optionPressed() -> void:
	var button = $Background/OptionsButton
	button.modulate.a = 0.5
	await get_tree().create_timer(0.1).timeout
	button.modulate.a = 1.0
	PlayerSound.playSound(PlayerSound.Sound.SELECT)
