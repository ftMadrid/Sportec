class_name PlayerStateHurt
extends PlayerState

const hurt_duration := 1000
const air_fric := 35.0
const height_vel := 2.5

var time_hurt := Time.get_ticks_msec()

func _enter_tree() -> void:
	player_animation.play("hurt")
	time_hurt = Time.get_ticks_msec()
	player.height_velocity = height_vel
	player.height = 0.1
	if ball.carrier == player:
		ball.tumble(state_data.hurt_direction * 100.0)

func _physics_process(delta: float) -> void:
	if Time.get_ticks_msec() - time_hurt > hurt_duration:
		trans_state(Player.State.RECOVERING)
	player.velocity = player.velocity.move_toward(Vector2.ZERO, delta * air_fric)
