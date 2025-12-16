extends Node

class Partido:
	var id: String
	var home: String
	var away: String
	var home_score: int = 0
	var away_score: int = 0
	var played: bool = false
	var winner: String = ""

var matchs = {}
var player_team_name: String = "" 

const ALL_TEAMS = [
	"REALMADRID", "BARCELONA", "AC.MILAN", "BAYERNMUNICH", 
	"INTER", "LIVERPOOL", "M.UNITED", "ARSENAL"
]

func _ready():
	randomize()

func startTournament():
	matchs.clear()
	
	player_team_name = GameManager.player_setup[0]
	if player_team_name == "": player_team_name = "REALMADRID"
	
	# Random the teams
	var teams_shuffled = GameManager.AVAILABLE_TEAMS.duplicate()
	randomize()
	teams_shuffled.shuffle()
	
	# Quarter finals
	for i in range(4):
		createMatch("Q" + str(i+1), teams_shuffled[i*2], teams_shuffled[i*2+1])
		
	# Void spaces for the tournament
	createMatch("S1", "", "")
	createMatch("S2", "", "")
	createMatch("F", "", "")

func createMatch(id, home, away):
	var p = Partido.new()
	p.id = id
	p.home = home
	p.away = away
	matchs[id] = p

func getNextPlayerMatch():
	for id in matchs:
		var p = matchs[id]
		if not p.played:
			if p.home == player_team_name or p.away == player_team_name:
				return p
	return null

func registerPlayerResult(goals_favor, goals_against):
	var p = getNextPlayerMatch()
	if p == null: return 
	
	p.home_score = goals_favor if p.home == player_team_name else goals_against
	p.away_score = goals_against if p.home == player_team_name else goals_favor
	p.played = true
	
	if goals_favor >= goals_against:
		p.winner = player_team_name
	else:
		p.winner = p.away if p.home == player_team_name else p.home
	
	advancerBracket(p)
	
	simulatedMatchIA(p.id)

func simulatedMatchIA(round_reference: String):
	var simulated_matches = []
	
	if "Q" in round_reference:
		simulated_matches = ["Q1", "Q2", "Q3", "Q4"]
	elif "S" in round_reference:
		simulated_matches = ["S1", "S2"]
	elif "F" in round_reference:
		simulated_matches = ["F"]
	
	for id in simulated_matches:
		var p = matchs[id]
		
		# conditions (no played, teams ready and not the team selected (to prevent crash yeah))
		if not p.played and p.home != "" and p.away != "":
			if p.home != player_team_name and p.away != player_team_name:
				simulatedRandomResult(p)

func simulatedRandomResult(p):
	p.home_score = randi() % 4
	p.away_score = randi() % 4
	if p.home_score == p.away_score: p.home_score += 1
	p.played = true
	p.winner = p.home if p.home_score > p.away_score else p.away
	advancerBracket(p)
	
func simulatedNextRoundSpectator():
	# just to check that is complete quarters
	for id in ["Q1", "Q2", "Q3", "Q4"]:
		if not matchs[id].played:
			simulatedMatchIA("Q1") # simulated all the round
			return

	# check that is complete semis
	for id in ["S1", "S2"]:
		if not matchs[id].played:
			simulatedMatchIA("S1") # Simula toda la ronda S
			return

	# check that is complete final
	if not matchs["F"].played:
		simulatedMatchIA("F")
		return

func advancerBracket(p):
	var winner = p.winner
	match p.id:
		"Q1": matchs["S1"].home = winner
		"Q2": matchs["S1"].away = winner
		"Q3": matchs["S2"].home = winner
		"Q4": matchs["S2"].away = winner
		"S1": matchs["F"].home = winner
		"S2": matchs["F"].away = winner
