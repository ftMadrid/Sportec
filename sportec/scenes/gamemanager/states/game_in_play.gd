class_name GameStateInPlay
extends GameState

func _enter_tree() -> void:
	GameEvents.team_scored.connect(team_scored.bind())

func _physics_process(delta: float) -> void:
	manager.time_left -= delta
	if manager.isTimeUp():
		if manager.isGameTied():
			trans_state(GameManager.State.OVERTIME)
		else:
			trans_state(GameManager.State.GAMEOVER)

func team_scored(team_scored_on: String) -> void:
	trans_state(GameManager.State.SCORED, GameStateData.build().set_team_scored(team_scored_on))
