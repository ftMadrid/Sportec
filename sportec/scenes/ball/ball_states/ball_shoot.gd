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
	shoot_particles.emitting = true
	GameEvents.impact_received.emit(ball.position, true)
	
func _physics_process(delta: float) -> void:
	if Time.get_ticks_msec() - since_shoot > shoot_duration:
		transState(Ball.State.FREEFORM)
	else:
		moveBounce(delta)

func _exit_tree() -> void:
	bsprite.scale.y	= 1.0
	shoot_particles.emitting = false
