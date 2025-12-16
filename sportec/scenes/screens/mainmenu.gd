extends Screen

@onready var menu_animation : AnimationPlayer = %MenuAnimation
@onready var plane_animation : AnimationPlayer = %PlaneAnimation

func _ready() -> void:
	menu_animation.play("start")
	menu_animation.animation_finished.connect(_on_menu_animation_finished)
	
	MusicManager.play_music("menu")
	start_plane_timer()

func _on_menu_animation_finished(anim_name: String) -> void:
	if anim_name == "start":
		menu_animation.play("background_animation")

func start_plane_timer() -> void:
	var timer = Timer.new()
	timer.wait_time = 19.0
	timer.autostart = true
	timer.one_shot = false
	add_child(timer)
	timer.timeout.connect(_on_plane_timer_timeout)

func _on_plane_timer_timeout() -> void:
	plane_animation.play("plane_pass")

func playPressed() -> void:
	var button = $Background/PlayButton
	button.modulate.a = 0.5
	await get_tree().create_timer(0.1).timeout
	button.modulate.a = 1.0
	PlayerSound.playSound(PlayerSound.Sound.SELECT)
	transScreen(GamePreset.Screens.TEAM_SELECTOR)

func optionPressed() -> void:
	var button = $Background/OptionsButton
	button.modulate.a = 0.5
	await get_tree().create_timer(0.1).timeout
	button.modulate.a = 1.0
	PlayerSound.playSound(PlayerSound.Sound.SELECT)
	#transScreen(GamePreset.Screens.OPTIONS)
