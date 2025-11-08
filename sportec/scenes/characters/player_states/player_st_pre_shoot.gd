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
	
func _physics_process(_delta: float) -> void:
	
	var input_vec := Input.get_vector(
		"p_left", 
		"p_right", 
		"p_up", 
		"p_down"
	)
	if input_vec != Vector2.ZERO:
		shoot_direction = input_vec
	
	if Input.is_action_just_released("p_shoot"):
		var duration_press := clampf(Time.get_ticks_msec() - start_shoot, 0.0, max_duration)
		var st_time := duration_press / max_duration
		var bonus := ease(st_time, ease_factor)
		var shoot_power := player.power * (1.0 + bonus)
		shoot_direction = shoot_direction.normalized()
		print(shoot_power, shoot_direction)
