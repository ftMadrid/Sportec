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
var active_screen = null
var is_tournament_mode: bool = false

const TEAMS_DATA_RES := "res://assets/json/teams_stats.json"
const TEAMS_DATA_USER := "user://teams_stats.json"
const SETTINGS_PATH = "user://settings.json"
var teams_info : Dictionary = {}

var game_settings = {
	"master": 1.0,
	"music": 0.25,
	"sfx": 0.9
}

func _init() -> void:
	process_mode = ProcessMode.PROCESS_MODE_ALWAYS
	loadTeamsData()
	loadSettings()

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

func resolveFortreit() -> void:
	if is_tournament_mode:
		var my_goals = randi_range(0, 2)
		var cpu_goals = my_goals + randi_range(1, 3)
		
		if teams[0] == player_setup[0]:
			score[0] = my_goals
			score[1] = cpu_goals
		else:
			score[0] = cpu_goals
			score[1] = my_goals
	
	switchState(State.GAMEOVER)

func loadTeamsData():
	if FileAccess.file_exists(TEAMS_DATA_USER):
		var file = FileAccess.open(TEAMS_DATA_USER, FileAccess.READ)
		teams_info = JSON.parse_string(file.get_as_text())
	else:
		var default_data = FileAccess.get_file_as_string(TEAMS_DATA_RES)
		teams_info = JSON.parse_string(default_data)
		saveTeamData()

func saveTeamData():
	var file = FileAccess.open(TEAMS_DATA_USER, FileAccess.WRITE)
	file.store_string(JSON.stringify(teams_info, "\t"))

func addCuptoTeam(team_name: String):
	if teams_info.has(team_name):
		teams_info[team_name]["cups"] += 1
		saveTeamData()

func loadSettings() -> void:
	if FileAccess.file_exists(SETTINGS_PATH):
		var file = FileAccess.open(SETTINGS_PATH, FileAccess.READ)
		var text = file.get_as_text()
		game_settings = JSON.parse_string(text)
	
	applyVolume(0, game_settings["master"])
	applyVolume(AudioServer.get_bus_index("Music"), game_settings["music"])
	applyVolume(AudioServer.get_bus_index("Sfx"), game_settings["sfx"])

func saveSettings() -> void:
	var file = FileAccess.open(SETTINGS_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(game_settings))

func applyVolume(bus_idx: int, value: float) -> void:
	AudioServer.set_bus_volume_db(bus_idx, linear_to_db(value))
	AudioServer.set_bus_mute(bus_idx, value < 0.01)
