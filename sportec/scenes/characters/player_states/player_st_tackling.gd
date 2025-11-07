class_name PlayerStateTackling
extends PlayerState

const tackle_duration := 100
const gr_friction := 250.0

var tackle_complete := false
var time_finish_tackle := Time.get_ticks_msec()

func _enter_tree() -> void:
	player_animation.play("tackle")
	
func _physics_process(delta: float) -> void:
	if not tackle_complete:
		player.velocity = player.velocity.move_toward(Vector2.ZERO, delta * gr_friction)
		if player.velocity == Vector2.ZERO:
			tackle_complete = true
			time_finish_tackle = Time.get_ticks_msec()

	elif Time.get_ticks_msec() - time_finish_tackle > tackle_duration:
		state_transition_requested.emit(Player.State.RECOVERING)
