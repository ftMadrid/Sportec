extends CanvasLayer

@onready var resume_button = $ResumeButton
@onready var exit_button = $ExitButton
@onready var anim_player: AnimationPlayer = $AnimationPlayer 

var saved_volume: float = -10.0 

func _ready() -> void:
	visible = false
	
	if resume_button:
		if not resume_button.pressed.is_connected(resumePressed):
			resume_button.pressed.connect(resumePressed)
	
	if exit_button:
		if not exit_button.pressed.is_connected(exitPressed):
			exit_button.pressed.connect(exitPressed)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		togglePause()

func togglePause() -> void:
	var is_paused = not get_tree().paused
	get_tree().paused = is_paused
	
	if !is_paused:
		if owner and owner.has_method("showPauseButton"):
			owner.showPauseButton()
		elif get_parent().has_method("showPauseButton"):
			get_parent().showPauseButton()

		if anim_player:
			anim_player.play("RESET")
		
		MusicManager.player.volume_db = saved_volume
		
		visible = false 
			
	else:
		saved_volume = MusicManager.player.volume_db
		MusicManager.player.volume_db = saved_volume - 15.0
		PlayerSound.playSound(PlayerSound.Sound.SELECT)
		
		if anim_player:
			anim_player.play("start")
			anim_player.advance(0)

		visible = true

func resumePressed() -> void:
	resume_button.modulate.a = 0.5
	await get_tree().create_timer(0.1).timeout
	resume_button.modulate.a = 1.0
	PlayerSound.playSound(PlayerSound.Sound.SELECT)
	togglePause()

func exitPressed() -> void:
	PlayerSound.playSound(PlayerSound.Sound.SELECT)
	
	get_tree().paused = false
	
	MusicManager.player.volume_db = saved_volume
	
	visible = false
	
	if anim_player:
		anim_player.play("RESET")
	
	if GameManager.is_tournament_mode:
		GameManager.resolveFortreit()
			
	else:
		if GameManager.active_screen:
			GameManager.active_screen.transScreen(GamePreset.Screens.MAINMENU)
		else:
			get_tree().change_scene_to_file("res://scenes/ui/ui.tscn")
