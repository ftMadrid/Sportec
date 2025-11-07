class_name PlayerStateFactory

var states : Dictionary

func _init() -> void:
	states = {
		Player.State.MOVING: PlayerStateMoving,
		Player.State.TACKLING: PlayerStateTackling,
		Player.State.RECOVERING: PlayerStateRecovering,
	}

func get_state(state: Player.State) -> PlayerState:
	assert(states.has(state), " that state doesnt exists!")
	return states.get(state).new()
