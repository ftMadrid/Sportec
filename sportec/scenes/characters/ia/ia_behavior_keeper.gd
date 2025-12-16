class_name IABehaviorKeeper
extends IABehavior

func ia_movement() -> void:
	var total_st_force := keeper_st_force()
	total_st_force = total_st_force.limit_length(1.0)
	player.velocity = total_st_force * player.speed

func ia_decisions() -> void:
	if ball.headed_scoring_are(player.own_goal.get_scoring_area()):
		player.switchState(Player.State.DIVING)

func keeper_st_force() -> Vector2:
	var top := player.own_goal.top_target_pos()
	var bottom := player.own_goal.bottom_target_pos()
	var center := player.spawn_position
	var target_y := clampf(ball.position.y, top.y, bottom.y)
	var destination := Vector2(center.x, target_y)
	var dir := player.position.direction_to(destination)
	var dist_to_dest := player.position.distance_to(destination)
	var weight := clampf(dist_to_dest / 10.0, 0, 1)
	return weight * dir
