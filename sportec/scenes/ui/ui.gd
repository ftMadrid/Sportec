class_name UI
extends CanvasLayer

@onready var team_img : Array[TextureRect] = [%HomeTeam, %AwayTeam]
@onready var score_text : Label = %Score
@onready var time_text : Label = %TimeLabel
@onready var player_text : Label = %PlayerLabel
@onready var player_animation : AnimationPlayer = %AnimationPlayer
@onready var goal_score : Label = %GoalScore
@onready var score_info : Label = %ScoreInfo

var last_ball_carrier := ""

func _ready() -> void:
	updateScore()
	updateTeams()
	updateTime()
	player_text.text = ""
	GameEvents.ball_possessed.connect(ballPossessed.bind())
	GameEvents.ball_released.connect(ballReleased.bind())
	GameEvents.score_change.connect(scoreChange.bind())
	GameEvents.teamReset.connect(teamReset.bind())
	GameEvents.gameover.connect(gameOver.bind())

func _physics_process(_delta: float) -> void:
	updateTime()

func updateScore() -> void:
	score_text.text = GameHelpers.getScoreText(GameManager.score)

func updateTeams() -> void:
	for i in team_img.size():
		team_img[i].texture = GameHelpers.getTexture(GameManager.teams[i])

func updateTime() -> void:
	if GameManager.time_left < 0:
		time_text.add_theme_color_override("font_color", Color.RED)
	time_text.text = GameHelpers.getTimeText(GameManager.time_left, GameManager.score)

func ballPossessed(player_name: String) -> void:
	player_text.text = player_name
	last_ball_carrier = player_name

func ballReleased() -> void:
	player_text.text = "N/A"

func scoreChange() -> void:
	if not GameManager.isTimeUp():
		goal_score.text = "%s HAS SCORED!" % [last_ball_carrier]
		score_info.text = GameHelpers.getCurrentScoreInfo(GameManager.teams, GameManager.score)
		player_animation.play("goal_popup")
	updateScore()
	
func teamReset() -> void:
	if GameManager.hasSomeoneScored():
		player_animation.play("goal_hide")

func gameOver(_team_winner: String) -> void:
	score_info.text = GameHelpers.getFinalScore(GameManager.teams, GameManager.score)
	player_animation.play("game_timeups") 
