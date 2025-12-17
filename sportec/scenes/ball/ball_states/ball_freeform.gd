class_name BallStateFreeForm
extends BallState

var time_freeform := Time.get_ticks_msec()

func _enter_tree() -> void:
	detection_area.body_entered.connect(playerEnter.bind())
	time_freeform = Time.get_ticks_msec()

func _physics_process(delta: float) -> void:
	detection_area.monitoring = (Time.get_ticks_msec() - time_freeform > state_data.lock_duration)
	set_ball_animation_velocity()
	var fric := ball.air_fric if ball.height > 0 else ball.ground_fric
	ball.velocity = ball.velocity.move_toward(Vector2.ZERO, fric * delta)
	gravityProcess(delta, 0.8)
	moveBounce(delta)

func playerEnter(body: Player) -> void:
	if body.canCarryBall() and ball.height < 25:
		ball.carrier = body
		body.controlBall()
		transState(Ball.State.CARRIED)
		GameEvents.ball_possessed.emit(body.pname)

func inAirAction() -> bool:
	return true
