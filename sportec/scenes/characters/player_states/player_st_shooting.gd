class_name PlayerStateShooting
extends PlayerState

func _enter_tree() -> void:
	player_animation.play("kick")

func animation_complete() -> void:
	if player.control_scheme == Player.ControlScheme.CPU:
		trans_state(Player.State.RECOVERING)
	else:
		trans_state(Player.State.MOVING)
	shoot_ball()

func shoot_ball() -> void:
	ball.shoot(state_data.shoot_direction * state_data.shoot_power)
