class_name GameStateReset
extends GameState

func _enter_tree() -> void:
	GameEvents.teamReset.emit()
	GameEvents.kickoff_ready.connect(kickoffReady.bind())

func kickoffReady() -> void:
	transState(GameManager.State.KICKOFF, state_data)
