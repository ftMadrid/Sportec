class_name BallStateFreeForm
extends BallState

func _enter_tree() -> void:
	detection_area.body_entered.connect(player_enter.bind())

func player_enter(body: Player) -> void:
	ball.carrier = body
	transition_state.emit(Ball.State.CARRIED)

func _physics_process(delta: float) -> void:
	set_ball_animation_velocity()
	var fric := ball.air_fric if ball.height > 0 else ball.ground_fric
	ball.velocity = ball.velocity.move_toward(Vector2.ZERO, fric * delta)
	gravity_process(delta, 0.8)
	move_bounce(delta)

func in_air_action() -> bool:
	return true
