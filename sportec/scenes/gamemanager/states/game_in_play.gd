class_name GameStateInPlay
extends GameState

func _enter_tree() -> void:
	GameEvents.teamScored.connect(teamScored.bind())

func _physics_process(delta: float) -> void:
	manager.time_left -= delta
	if manager.isTimeUp():
		if manager.isGameTied():
			transState(GameManager.State.OVERTIME)
		else:
			transState(GameManager.State.GAMEOVER)

func teamScored(team_scored_on: String) -> void:
	transState(GameManager.State.SCORED, GameStateData.build().setTeamScored(team_scored_on))
