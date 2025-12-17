class_name IABehaviorKeeper
extends IABehavior

func iaMovement() -> void:
	var total_st_force := keeperForce()
	total_st_force = total_st_force.limit_length(1.0)
	player.velocity = total_st_force * player.speed

func iaDecisions() -> void:
	if ball.headScoring(player.own_goal.getScoringArea()):
		player.switchState(Player.State.DIVING)

func keeperForce() -> Vector2:
	var top := player.own_goal.topTargetPos()
	var bottom := player.own_goal.bottomTargetPos()
	var center := player.spawn_position
	var target_y := clampf(ball.position.y, top.y, bottom.y)
	var destination := Vector2(center.x, target_y)
	var dir := player.position.direction_to(destination)
	var dist_to_dest := player.position.distance_to(destination)
	var weight := clampf(dist_to_dest / 10.0, 0, 1)
	return weight * dir
