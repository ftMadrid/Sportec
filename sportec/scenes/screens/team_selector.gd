extends Screen

var animated = false
var start_pos: Vector2

var current_team_index = 0 

@export var player_index: int = 0 

@onready var team : TextureRect = $Background/TeamImage

func _ready() -> void:
	MusicManager.play_music("menu") 
	start_pos = Vector2(72, 73) 

	var team_name = GameManager.AVAILABLE_TEAMS[current_team_index]
	team.texture = GameHelpers.getTexture(team_name)
	updateGameManagerTeams()
	
	if has_node("AnimationPlayer"):
		$AnimationPlayer.play("start")

func leftButtonPressed() -> void:
	if animated: return
	
	var button = $Background/LeftButton
	button.modulate.a = 0.5
	await get_tree().create_timer(0.1).timeout
	button.modulate.a = 1.0
	PlayerSound.playSound(PlayerSound.Sound.NAVIGATION)
	changeImageAnimation(false)

func rightButtonPressed() -> void:
	if animated: return

	var button = $Background/RightButton
	button.modulate.a = 0.5
	await get_tree().create_timer(0.1).timeout
	button.modulate.a = 1.0
	PlayerSound.playSound(PlayerSound.Sound.NAVIGATION)
	changeImageAnimation(true)

func changeImageAnimation(right: bool) -> void:
	animated = true
	
	var offscreen_x = 60
	var start_x = start_pos.x + (offscreen_x if right else -offscreen_x)
	team.position = Vector2(start_x, start_pos.y)
	
	var total_teams = GameManager.AVAILABLE_TEAMS.size()
	
	if right:
		current_team_index += 1
		if current_team_index >= total_teams:
			current_team_index = 0
	else:
		current_team_index -= 1
		if current_team_index < 0:
			current_team_index = total_teams - 1

	var team_name = GameManager.AVAILABLE_TEAMS[current_team_index]
	team.texture = GameHelpers.getTexture(team_name)
	
	updateGameManagerTeams()
	
	var tween = create_tween()
	tween.tween_property(team, "position", start_pos, 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.finished.connect(Callable(self, "animationFinished"))

func animationFinished():
	animated = false

func updateGameManagerTeams():
	var selected_team = GameManager.AVAILABLE_TEAMS[current_team_index]
	
	GameManager.teams[player_index] = selected_team

	if GameManager.player_setup.size() > player_index:
		GameManager.player_setup[player_index] = selected_team

func backButtonPressed() -> void:
	var button = $Background/BackButton
	button.modulate.a = 0.5
	await get_tree().create_timer(0.1).timeout
	button.modulate.a = 1.0
	PlayerSound.playSound(PlayerSound.Sound.SELECT)
	transScreen(GamePreset.Screens.MAINMENU)

func startButtonPressed() -> void:
	var button = $Background/StartButton
	button.modulate.a = 0.5
	await get_tree().create_timer(0.1).timeout
	button.modulate.a = 1.0
	
	# 1. Guardar el equipo que elegiste
	updateGameManagerTeams()
	
	# 2. IMPORTANTE: ¡Crear el torneo nuevo con ese equipo!
	# Esto reinicia los cruces y te pone a ti en el primer partido
	TournamentManager.startTournament()
	
	PlayerSound.playSound(PlayerSound.Sound.SELECT)
	
	# 3. Ahora sí, ir a la pantalla del torneo
	transScreen(GamePreset.Screens.TOURNAMENT)
	
