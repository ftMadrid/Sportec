class_name GameStateReset
extends GameState

func _enter_tree() -> void:
	GameEvents.teamReset.emit()
	GameEvents.kickoff_ready.connect(kickoffReady.bind())

func kickoffReady() -> void:
	transState(GameManager.State.KICKOFF, state_data)

func _exit_tree() -> void:
	if GameEvents.kickoff_ready.is_connected(kickoffReady):
		GameEvents.kickoff_ready.disconnect(kickoffReady)
