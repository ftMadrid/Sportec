class_name PlayerStateDiving
extends PlayerState

const duration_dive := 500

var start_dive := Time.get_ticks_msec()

func _enter_tree() -> void:
	var target_dive := Vector2(player.spawn_position.x, ball.position.y)
	var dir := player.position.direction_to(target_dive)
	if dir.y > 0:
		player_animation.play("dive_down")
	else:
		player_animation.play("dive_up")
	player.velocity = dir * player.speed
	start_dive = Time.get_ticks_msec()

func _physics_process(_delta: float) -> void:
	if Time.get_ticks_msec() - start_dive > duration_dive:
		transState(Player.State.RECOVERING)
