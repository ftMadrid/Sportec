class_name BallStateShoot
extends BallState

const shoot_scale := 0.8
const shoot_height := 5
const shoot_duration := 1000

var since_shoot := Time.get_ticks_msec()

func _enter_tree() -> void:
	set_ball_animation_velocity()
	bsprite.scale.y = shoot_scale
	ball.height = shoot_height
	since_shoot = Time.get_ticks_msec()
	
func _physics_process(delta: float) -> void:
	if Time.get_ticks_msec() - since_shoot > shoot_duration:
		transition_state.emit(Ball.State.FREEFORM)
	else:
		move_bounce(delta)

func _exit_tree() -> void:
	bsprite.scale.y	= 1.0
