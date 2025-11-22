class_name PlayerStateMoving
extends PlayerState

func _physics_process(_delta: float) -> void:
	if player.control_scheme == Player.ControlScheme.CPU:
		pass # the movements for the AI (is bug now so dont try to collide with a cpu bro
	else:
		handle_human_moves()
		
	player.movement_animation()
	player.set_heading()
	
func handle_human_moves() -> void:
	var dir := KeyUtils.get_input_vector(player.control_scheme)
	player.velocity = dir * player.speed
	
	if player.velocity != Vector2.ZERO:
		teammate_area.rotation = player.velocity.angle()
		
	if player.has_ball():
		if KeyUtils.action_just_pressed(player.control_scheme, KeyUtils.Action.PASS): # checks if the player has the ball to make the pass
			trans_state(Player.State.PASSING)
		elif KeyUtils.action_just_pressed(player.control_scheme, KeyUtils.Action.SHOOT): # checks if the player has the ball to make the shoot
			trans_state(Player.State.PREP_SHOOT)
	elif ball.in_air_action() and KeyUtils.action_just_pressed(player.control_scheme, KeyUtils.Action.SHOOT):
		if player.velocity == Vector2.ZERO:
			if facing_target_goal():
				trans_state(Player.State.VOLLEY)
			else:
				trans_state(Player.State.BICYCLE)
		else:
			trans_state(Player.State.HEADER)
	
	#if !player.has_ball() and KeyUtils.action_just_pressed(player.control_scheme, KeyUtils.Action.SHOOT):
		#trans_state(Player.State.TACKLING)

func facing_target_goal() -> bool:
	var dir_target_goal := player.position.direction_to(target_goal.position)
	return player.heading.dot(dir_target_goal) > 0 # return angle of the heading
