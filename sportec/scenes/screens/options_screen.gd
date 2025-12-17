extends Screen

@onready var master_slider: HSlider = $Master
@onready var music_slider: HSlider = $Music
@onready var sound_slider: HSlider = $Sound

func _ready() -> void:
	MusicManager.playMusic("menu")
	
	master_slider.value = db_to_linear(AudioServer.get_bus_volume_db(0))
	music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
	sound_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Sfx")))
	
	master_slider.value_changed.connect(masterValueChanged)
	music_slider.value_changed.connect(musicValueChanged)
	sound_slider.value_changed.connect(soundValueChanged)

func masterValueChanged(value: float) -> void:
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(0, db)
	AudioServer.set_bus_mute(0, value < 0.01)
	GameManager.game_settings["master"] = value

func musicValueChanged(value: float) -> void:
	var db = linear_to_db(value)
	var idx = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_db(idx, db)
	AudioServer.set_bus_mute(idx, value < 0.01)
	GameManager.game_settings["music"] = value

func soundValueChanged(value: float) -> void:
	var idx = AudioServer.get_bus_index("Sfx")
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(idx, db)
	AudioServer.set_bus_mute(idx, value < 0.01)
	
	GameManager.game_settings["sfx"] = value
	
	var player = PlayerSound.findAvailablePlayer()
	if player:
		PlayerSound.playSound(PlayerSound.Sound.NAVIGATION)

func backPressed() -> void:
	GameManager.saveSettings()
	
	var button = $BackButton
	button.modulate.a = 0.5
	await get_tree().create_timer(0.1).timeout
	button.modulate.a = 1.0
	PlayerSound.playSound(PlayerSound.Sound.SELECT)
	transScreen(GamePreset.Screens.MAINMENU)
