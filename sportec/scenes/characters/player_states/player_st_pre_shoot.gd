class_name PlayerStatePrepShoot
extends PlayerState

const max_duration := 1000.0
const ease_factor := 2.0

var start_shoot := Time.get_ticks_msec()
var shoot_direction := Vector2.ZERO

func _enter_tree() -> void:
	player_animation.play("pre_kick")
	player.velocity = Vector2.ZERO
	start_shoot = Time.get_ticks_msec()
	shoot_direction = player.heading # to can shoot being idle
	
func _physics_process(delta: float) -> void:
	
	shoot_direction += KeyUtils.get_input_vector(player.control_scheme) * delta
	
	if KeyUtils.action_just_released(player.control_scheme, KeyUtils.Action.SHOOT):
		var duration_press := clampf(Time.get_ticks_msec() - start_shoot, 0.0, max_duration)
		var st_time := duration_press / max_duration
		var bonus := ease(st_time, ease_factor)
		var shoot_power := player.power * (1 + bonus)
		shoot_direction = shoot_direction.normalized()
		var data = PlayerStateData.build().set_shoot_power(shoot_power).set_shoot_direction(shoot_direction)
		print(shoot_power, shoot_direction)
		trans_state(Player.State.SHOOTING, data)
