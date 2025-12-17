class_name PlayerStateVolley
extends PlayerState

const extra_power := 1.5
const height_min := 1.0
const height_max := 20.0

func _enter_tree() -> void:
	player_animation.play("volley")
	ball_area.body_entered.connect(ballEntered.bind())

func ballEntered(tact_ball: Ball) -> void:
	if tact_ball.airConnect(height_min, height_max):
		var dest := target_goal.randomTargetPos()
		var dir := ball.position.direction_to(dest)
		PlayerSound.playSound(PlayerSound.Sound.POWERSHOOT)
		tact_ball.shoot(dir * player.power * extra_power)

func animation_complete() -> void:
	transState(Player.State.RECOVERING)
