extends Screen

@onready var team_logo = $Background/TeamLogo
@onready var winner_label = $Background/WinnerLabel

func _ready() -> void:
	MusicManager.playMusic("winner")

	var winner_name = TournamentManager.matchs["F"].winner
	
	if winner_name == "":
		winner_name = "REALMADRID"
		
	winner_label.text = winner_name + " WINS THE CLUB WORLD CUP!"
	team_logo.texture = GameHelpers.getTexture(winner_name)

func buttonPressed() -> void:
	PlayerSound.playSound(PlayerSound.Sound.SELECT)
	transScreen(GamePreset.Screens.MAINMENU)
