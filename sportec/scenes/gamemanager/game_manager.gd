extends Node

const game_duration := 2*60
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

func _init() -> void:
	process_mode = ProcessMode.PROCESS_MODE_ALWAYS

func _ready() -> void:
	time_left = game_duration
	GameEvents.kickoff_ready.connect(on_kickoff_ready)
	switch_st(State.RESET)

func on_kickoff_ready() -> void:
	switch_st(State.PLAY)

func switch_st(state: State, data: GameStateData = GameStateData.new()) -> void:
	if current_state != null:
		current_state.queue_free()
	current_state = state_fact.get_fresh_state(state)
	current_state.setup(self, data)
	current_state.transition_state.connect(switch_st.bind())
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

func increaseScore(team_scored: String) -> void:
	var i_team_scored := 1 if team_scored == teams[0] else 0
	score[i_team_scored] += 1
	GameEvents.score_change.emit()

func hasSomeoneScored() -> bool:
	return score[0] > 0 or score[1] > 0
