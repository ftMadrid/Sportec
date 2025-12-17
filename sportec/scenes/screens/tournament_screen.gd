extends Screen
class_name TournamentScreen

var team_logos = {
	"REALMADRID": preload("res://assets/art/ui/teams/team-realmadrid.png"),
	"BARCELONA": preload("res://assets/art/ui/teams/team-barcelona.png"),
	"AC.MILAN": preload("res://assets/art/ui/teams/team-ac.milan.png"),
	"BAYERNMUNICH": preload("res://assets/art/ui/teams/team-bayernmunich.png"),
	"ARSENAL": preload("res://assets/art/ui/teams/team-arsenal.png"),
	"M.UNITED": preload("res://assets/art/ui/teams/team-m.united.png"),
	"INTER": preload("res://assets/art/ui/teams/team-inter.png"),
	"LIVERPOOL": preload("res://assets/art/ui/teams/team-liverpool.png"),
}

func _ready():
	MusicManager.playMusic("menu")
	updateValues()

func updateValues():
	var ids = ["Q1", "Q2", "Q3", "Q4", "S1", "S2", "F"]
	
	for id in ids:
		if not TournamentManager.matchs.has(id):
			continue
			
		var data = TournamentManager.matchs[id]

		var node_home = find_child("Home" + id, true, false)
		var node_away = find_child("Away" + id, true, false)
		var node_score = find_child("Score" + id, true, false)
		
		if node_home == null or node_away == null:
			print("There is no node for the match " + id)
			continue

		if data.home != "":
			node_home.texture = team_logos.get(data.home)
			if data.played and data.winner != data.home:
				node_home.modulate = Color.DIM_GRAY
			else:
				node_home.modulate = Color.WHITE
		else:
			node_home.modulate = Color(1,1,1,0.5)
				
		if data.away != "":
			node_away.texture = team_logos.get(data.away)
			if data.played and data.winner != data.away:
				node_away.modulate = Color.DIM_GRAY
			else:
				node_away.modulate = Color.WHITE
		else:
			node_away.modulate = Color(1,1,1,0.5)
		
		if node_score:
			if data.played:
				node_score.text = str(data.home_score) + " - " + str(data.away_score)
				node_score.visible = true
			else:
				node_score.text = "VS"


func _on_button_pressed() -> void:
	var match_now = TournamentManager.getNextPlayerMatch()
	
	if match_now:
		var mi_equipo = TournamentManager.player_team_name
		GameManager.teams = [match_now.home, match_now.away]
		GameManager.player_setup = [mi_equipo, ""] 
		if GameManager.has_method("resetMatchData"): GameManager.resetMatchData()
		transScreen(GamePreset.Screens.IN_GAME)
		
	else:
		if TournamentManager.matchs["F"].played:
			var winner: String = TournamentManager.matchs["F"].winner
			print("Tournament Finished! Winner: " + winner)
			GameManager.addCuptoTeam(winner)
			transScreen(GamePreset.Screens.WINNER)
			
		else:
			TournamentManager.simulatedNextRoundSpectator()
			updateValues() 
			PlayerSound.playSound(PlayerSound.Sound.SELECT)
