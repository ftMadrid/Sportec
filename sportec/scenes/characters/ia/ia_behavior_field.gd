class_name IABehaviorField
extends IABehavior

const tackle_distance := 15

func iaMovement() -> void:
	var total_st_force := Vector2.ZERO
	if player.hasBall():
		total_st_force += carrierForce()
	elif ballCarriedByTeammate():
		total_st_force += assistFormation()
	else:
		total_st_force += dutySteering()
		if total_st_force.length_squared() < 1:
			if ballPossessedByOpponent():
				total_st_force += getSpawnForce()
			elif ball.carrier == null:
				total_st_force += ballProximityForce()
				total_st_force += getDensityAroundBall()
				
	total_st_force = total_st_force.limit_length(1.0)
	player.velocity = total_st_force * player.speed

func iaDecisions() -> void:
	if ballPossessedByOpponent() and player.position.distance_to(ball.position) < tackle_distance and randf() < 0.3:
		player.switchState(Player.State.TACKLING)
	
	if ball.carrier == player:
		var target := player.target_goal.centerTargetPos()
	
		if player.position.distance_to(target) < 150 and randf() < 0.3:
			player.faceTargetGoal()
			var shoot_dir := player.position.direction_to(player.target_goal.randomTargetPos())
			var data := PlayerStateData.build().setShootPower(player.power).setShootDirection(shoot_dir)
			player.switchState(Player.State.SHOOTING, data)
		elif randf() < 0.05 and nearbyOpponents() and hasTeammateView():
			player.switchState(Player.State.PASSING)

func dutySteering() -> Vector2:
	return player.weight_steering * player.position.direction_to(ball.position)

func carrierForce() -> Vector2:
	var target := player.target_goal.centerTargetPos()
	var dir := player.position.direction_to(target)
	var weight := bicircularWeight(player.position, target, 100, 0, 150, 1)
	return weight * dir

func assistFormation() -> Vector2:
	var spawn_diff := ball.carrier.spawn_position - player.spawn_position
	var assist_dest := ball.carrier.position - spawn_diff * 0.8
	var dir := player.position.direction_to(assist_dest)
	var weight := bicircularWeight(player.position, assist_dest, 30, 0.2, 60, 1)
	return weight * dir

func getDensityAroundBall() -> Vector2:
	var n_teammates := ball.getProximityTeammates(player.team)
	if n_teammates == 0:
		return Vector2.ZERO
	var weight := 1 - 1.0 / n_teammates
	var dir := ball.position.direction_to(player.position)
	return weight * dir
