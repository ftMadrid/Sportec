class_name PlayerStatePassing
extends PlayerState

func _enter_tree() -> void:
	player_animation.play("kick")
	player.velocity = Vector2.ZERO

func animation_complete() -> void:
	var pass_target := teammate_in_view()
	if pass_target == null: # to pass the ball to the real target and make the condition if is not null
		ball.pass_to(ball.position + player.heading * player.speed)
	else:
		ball.pass_to(pass_target.position + pass_target.velocity)
	trans_state(Player.State.MOVING)

func teammate_in_view() -> Player:
	var players_in_view := teammate_area.get_overlapping_bodies()
	var teammates_in_view := players_in_view.filter(
		func(p: Player): return p != player
	)
	teammates_in_view.sort_custom( # choose the nearest player for passing
		func(p1: Player, p2: Player): return p1.position.distance_squared_to(player.position) < p2.position.distance_squared_to(player.position)
	)
	if teammates_in_view.size() > 0:
		return teammates_in_view[0] # return the array vector to simplify nearest player search
	return null
