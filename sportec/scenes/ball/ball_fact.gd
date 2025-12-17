class_name BallStateFactory

var states : Dictionary

func _init() -> void:
	states = {
		Ball.State.CARRIED: BallStateCarried,
		Ball.State.SHOOT: BallStateShoot,
		Ball.State.FREEFORM: BallStateFreeForm,
	}
	
func getState(state: Ball.State) -> BallState:
	assert(states.has(state), " that state doesnt exists!")
	return states.get(state).new()
