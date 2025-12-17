extends Screen

@onready var menu_animation : AnimationPlayer = %MenuAnimation
@onready var plane_animation : AnimationPlayer = %PlaneAnimation

func _ready() -> void:
	menu_animation.play("start")
	menu_animation.animation_finished.connect(menuAnimationFinished)
	
	MusicManager.playMusic("menu")
	startPlaneTimer()

func menuAnimationFinished(anim_name: String) -> void:
	if anim_name == "start":
		menu_animation.play("background_animation")

func startPlaneTimer() -> void:
	var timer = Timer.new()
	timer.wait_time = 19.0
	timer.autostart = true
	timer.one_shot = false
	add_child(timer)
	timer.timeout.connect(planeTimerTimeout)

func planeTimerTimeout() -> void:
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
	transScreen(GamePreset.Screens.OPTIONS)
