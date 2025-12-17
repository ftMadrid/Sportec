extends Node

const game_duration := 5#60
const duration_impact := 100

enum State {PLAY, SCORED, RESET, KICKOFF, OVERTIME, GAMEOVER}

const AVAILABLE_TEAMS : Array[String] = [
	"REALMADRID", "BARCELONA", "AC.MILAN", "BAYERNMUNICH", 
	"INTER", "LIVERPOOL", "M.UNITED", "ARSENAL"
]

var time_left : float
var teams : Array[String] = ["REALMADRID", "BARCELONA"]
var score : Array[int] = [0, 0]
var state_fact := GameStateFactory.new()
var current_state : GameState = null
var player_setup : Array[String] = ["REALMADRID", ""]
var active_screen = null

func _init() -> void:
	process_mode = ProcessMode.PROCESS_MODE_ALWAYS

func _ready() -> void:
	time_left = game_duration
	GameEvents.kickoff_ready.connect(kickoffReady)
	switchState(State.RESET)

func kickoffReady() -> void:
	switchState(State.PLAY)

func switchState(state: State, data: GameStateData = GameStateData.new()) -> void:
	if current_state != null:
		current_state.queue_free()
	current_state = state_fact.getState(state)
	current_state.setup(self, data)
	current_state.transition_state.connect(switchState.bind())
	current_state.name = "| GameStateMachine: " + str(state)
	call_deferred("add_child", current_state)

func isCoop() -> bool:
	return player_setup[0] == player_setup[1]

func isSingle() -> bool:
	return player_setup[1].is_empty()

func getTeamWinner() -> String:
	assert(not isGameTied())
	return teams[0] if score[0] > score[1] else teams[1]
	
func isGameTied() -> bool:
	return score[0]  == score[1]

func isTimeUp() -> bool:
	return time_left <= 0

func increaseScore(teamScored: String) -> void:
	var i_team_scored := 1 if teamScored == teams[0] else 0
	score[i_team_scored] += 1
	GameEvents.score_change.emit()

func hasSomeoneScored() -> bool:
	return score[0] > 0 or score[1] > 0

func resetMatchData():
	score = [0, 0]
	
	time_left = game_duration 
	
	if current_state:
		current_state.queue_free()
		current_state = null
	
	switchState(State.RESET)
