class_name PlayerStateTackling
extends PlayerState

const tackle_duration := 200

var time_start_tackle := Time.get_ticks_msec()

func _enter_tree() -> void:
	player_animation.play("tackle")
	
func _physics_process(_delta: float) -> void:
	if Time.get_ticks_msec() - time_start_tackle > tackle_duration:
		state_transition_requested.emit(Player.State.MOVING)
