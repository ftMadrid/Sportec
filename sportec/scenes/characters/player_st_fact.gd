class_name PlayerStateFactory

var states : Dictionary

func _init() -> void:
	states = {
		Player.State.MOVING: PlayerStateMoving,
		Player.State.PASSING: PlayerStatePassing,
		Player.State.TACKLING: PlayerStateTackling,
		Player.State.RECOVERING: PlayerStateRecovering,
		Player.State.PREP_SHOOT: PlayerStatePrepShoot,
		Player.State.SHOOTING: PlayerStateShooting,
		Player.State.BICYCLE: PlayerStateBicycle,
		Player.State.VOLLEY: PlayerStateVolley,
		Player.State.HEADER: PlayerStateHeader,
	}

func get_state(state: Player.State) -> PlayerState:
	assert(states.has(state), " that state doesnt exists!")
	return states.get(state).new()
