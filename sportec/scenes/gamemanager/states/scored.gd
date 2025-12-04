class_name GameStateScored
extends GameState

const duration_celebration := 3000

var time_celebration := Time.get_ticks_msec()

func _enter_tree() -> void:
	var i_team_scored := 1 if state_data.team_scored == manager.teams[0] else 0
	manager.score[i_team_scored] += 1
	time_celebration = Time.get_ticks_msec()

func _physics_process(_delta: float) -> void:
	if Time.get_ticks_msec() - time_celebration > duration_celebration:
		trans_state(GameManager.State.RESET)
