class_name BallStateFreeForm
extends BallState

func _enter_tree() -> void:
	detection_area.body_entered.connect(player_enter.bind())

func player_enter(body: Player) -> void:
	ball.carrier = body
	state_transition_requested.emit(Ball.State.CARRIED)
