class_name BallStateFreeForm
extends BallState

var time_freeform := Time.get_ticks_msec()

func _enter_tree() -> void:
	detection_area.body_entered.connect(player_enter.bind())
	time_freeform = Time.get_ticks_msec()

func player_enter(body: Player) -> void:
	if body.can_carry_ball() and ball.height < 25:
		ball.carrier = body
		body.control_ball()
		trans_state(Ball.State.CARRIED)

func _physics_process(delta: float) -> void:
	detection_area.monitoring = (Time.get_ticks_msec() - time_freeform > state_data.lock_duration)
	set_ball_animation_velocity()
	var fric := ball.air_fric if ball.height > 0 else ball.ground_fric
	ball.velocity = ball.velocity.move_toward(Vector2.ZERO, fric * delta)
	gravity_process(delta, 0.8)
	move_bounce(delta)

func in_air_action() -> bool:
	return true
