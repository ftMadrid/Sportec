class_name GameStateReset
extends GameState

func _enter_tree() -> void:
	GameEvents.team_reset.emit()
	GameEvents.kickoff_ready.connect(kickoffReady.bind())

func kickoffReady() -> void:
	trans_state(GameManager.State.KICKOFF, state_data)
