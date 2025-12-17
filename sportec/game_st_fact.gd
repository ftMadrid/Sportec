class_name GameStateFactory

var states : Dictionary

func _init() -> void:
	states = {
		GameManager.State.PLAY: GameStateInPlay,
		GameManager.State.GAMEOVER: GameStateGameOver,
		GameManager.State.OVERTIME: GameStateOvertime,
		GameManager.State.SCORED: GameStateScored,
		GameManager.State.RESET: GameStateReset,
		GameManager.State.KICKOFF: GameStateKickoffs,
	}

func getState(state: GameManager.State) -> GameState:
	assert(states.has(state), " state doesnt exists!")
	return states.get(state).new()
