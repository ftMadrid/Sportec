class_name IABehaviorField
extends IABehavior

const tackle_distance := 15

func ia_movement() -> void:
	var total_st_force := Vector2.ZERO
	if player.has_ball():
		total_st_force += carrier_steering_force()
	elif ball_carried_by_teammate():
		total_st_force += assist_formation_st()
	else:
		total_st_force += duty_steering()
		if total_st_force.length_squared() < 1:
			if ball_possessed_by_opponent():
				total_st_force += get_spawn_st_force()
			elif ball.carrier == null:
				total_st_force += ball_proximity_st_force()
				
	total_st_force = total_st_force.limit_length(1.0)
	player.velocity = total_st_force * player.speed

func ia_decisions() -> void:
	if ball_possessed_by_opponent() and player.position.distance_to(ball.position) < tackle_distance and randf() < 0.3:
		player.switch_st(Player.State.TACKLING)
	
	if ball.carrier == player:
		var target := player.target_goal.center_target_position()
	
		if player.position.distance_to(target) < 150 and randf() < 0.3:
			player.face_target_goal()
			var shoot_dir := player.position.direction_to(player.target_goal.random_target_position())
			var data := PlayerStateData.build().set_shoot_power(player.power).set_shoot_direction(shoot_dir)
			player.switch_st(Player.State.SHOOTING, data)
		elif randf() < 0.05 and opponents_nearby() and has_teammate_view():
			player.switch_st(Player.State.PASSING)

func duty_steering() -> Vector2:
	return player.weight_steering * player.position.direction_to(ball.position)

func carrier_steering_force() -> Vector2:
	var target := player.target_goal.center_target_position()
	var dir := player.position.direction_to(target)
	var weight := bicircular_weight(player.position, target, 100, 0, 150, 1)
	return weight * dir

func assist_formation_st() -> Vector2:
	var spawn_diff := ball.carrier.spawn_position - player.spawn_position
	var assist_dest := ball.carrier.position - spawn_diff * 0.8
	var dir := player.position.direction_to(assist_dest)
	var weight := bicircular_weight(player.position, assist_dest, 30, 0.2, 60, 1)
	return weight * dir
