class_name PlayerStatePassing
extends PlayerState

func _enter_tree() -> void:
	player_animation.play("kick")
	player.velocity = Vector2.ZERO
	PlayerSound.playSound(PlayerSound.Sound.PASS)

func animation_complete() -> void:
	var pass_target := state_data.pass_target
	if pass_target == null:
		pass_target = teammateInView() # get the pass from other player (requested from player 1)
	if pass_target == null: # to pass the ball to the target and make the condition if is not null
		ball.passTo(ball.position + player.heading * player.speed)
	else:
		var dir := player.position.direction_to(pass_target.position)
		if sign(player.heading.x) != sign(dir.x):
			player.heading *= -1
		ball.passTo(pass_target.position + pass_target.velocity * 0.8)
	transState(Player.State.MOVING)

func teammateInView() -> Player:
	var players_in_view := teammate_area.get_overlapping_bodies()
	var teammates_in_view := players_in_view.filter(
		func(p: Player): return p != player and p.team == player.team
	)
	teammates_in_view.sort_custom( # choose the nearest player for passing
		func(p1: Player, p2: Player): return p1.position.distance_squared_to(player.position) < p2.position.distance_squared_to(player.position)
	)
	if teammates_in_view.size() > 0:
		return teammates_in_view[0] # return the array vector to simplify nearest player search
	return null
