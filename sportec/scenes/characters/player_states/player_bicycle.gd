class_name PlayerStateBicycle
extends PlayerState

const extra_power := 2.0
const height_min := 5.0
const height_max := 25.0

func _enter_tree() -> void:
	player_animation.play("bicycle")
	ball_area.body_entered.connect(ball_entered.bind())

func ball_entered(tact_ball: Ball) -> void:
	if tact_ball.air_connect(height_min, height_max):
		var dest := target_goal.random_target_position()
		var dir := ball.position.direction_to(dest)
		tact_ball.shoot(dir * player.power * extra_power)

func animation_complete() -> void:
	trans_state(Player.State.RECOVERING)
