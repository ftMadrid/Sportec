class_name GameStateScored
extends GameState

const duration_celebration := 3000

var time_celebration := Time.get_ticks_msec()

func _enter_tree() -> void:
	manager.increaseScore(state_data.team_scored)
	time_celebration = Time.get_ticks_msec()

func _physics_process(_delta: float) -> void:
	if Time.get_ticks_msec() - time_celebration > duration_celebration:
		trans_state(GameManager.State.RESET, state_data)
