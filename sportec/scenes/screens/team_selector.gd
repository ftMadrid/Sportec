extends Screen

var animated = false
var start_pos: Vector2
var start_pos_shadow: Vector2

var current_team_index = 0 

@export var player_index: int = 0 

@onready var team : TextureRect = $Background/TeamImage
@onready var shadow : TextureRect = $Background/Shadow
@onready var rhythm_label : Label = $Background/Rhythm
@onready var strength_label : Label = $Background/Strength
@onready var cups_label : Label = $Background/WorldCups
@onready var stats_title : Label = $Background/TeamName

func _ready() -> void:
	MusicManager.playMusic("menu") 
	start_pos = Vector2(72, 73)
	start_pos_shadow = Vector2(73, 146)

	var team_name = GameManager.AVAILABLE_TEAMS[current_team_index]
	team.texture = GameHelpers.getTexture(team_name)
	updateGameManagerTeams()
	updateStats(team_name)
	
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
	shadow.position = Vector2(start_x + 1, start_pos_shadow.y)

	var total_teams = GameManager.AVAILABLE_TEAMS.size()

	if right:
		current_team_index = (current_team_index + 1) % total_teams
	else:
		current_team_index = (current_team_index - 1 + total_teams) % total_teams

	var team_name = GameManager.AVAILABLE_TEAMS[current_team_index]
	team.texture = GameHelpers.getTexture(team_name)
	updateGameManagerTeams()
	updateStats(team_name) 

	var tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	tween.tween_property(team, "position", start_pos, 0.4)
	tween.parallel().tween_property(shadow, "position", start_pos_shadow, 0.4)
	tween.finished.connect(animationFinished)

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

	updateGameManagerTeams()
	
	TournamentManager.startTournament()
	
	PlayerSound.playSound(PlayerSound.Sound.SELECT)
	transScreen(GamePreset.Screens.TOURNAMENT)
	
func updateStats(team_name: String):
	var info = GameManager.teams_info.get(team_name, {"rhythm": 0, "strength": 0, "cups": 0})
	
	stats_title.text = team_name + " STATS"
	rhythm_label.text = "RHYTHM:  " + str(int(info.rhythm))
	strength_label.text = "STRENGTH:  " + str(int(info.strength))
	cups_label.text = "WORLD CUPS:  " + str(int(info.cups))
