class_name PlayerStateMoving
extends PlayerState

func _physics_process(_delta: float) -> void:
	if player.control_scheme == Player.ControlScheme.CPU:
		ia_behavior.process_ia()
	else:
		handle_human_moves()
		
	player.movement_animation()
	player.set_heading()
	
func handle_human_moves() -> void:
	var dir := KeyUtils.get_input_vector(player.control_scheme)
	player.velocity = dir * player.speed
	
	if player.velocity != Vector2.ZERO:
		teammate_area.rotation = player.velocity.angle()
		
	if KeyUtils.action_just_pressed(player.control_scheme, KeyUtils.Action.PASS):
		if player.has_ball():
			trans_state(Player.State.PASSING)
		elif can_teammate_pass_ball():
			ball.carrier.get_pass_req(player)
		else:
			player.swap_requested.emit(player)
	
	elif KeyUtils.action_just_pressed(player.control_scheme, KeyUtils.Action.SHOOT):
		if player.has_ball():
			trans_state(Player.State.PREP_SHOOT)
		elif ball.in_air_action():
			if player.velocity == Vector2.ZERO:
				if player.facing_target_goal():
					trans_state(Player.State.VOLLEY)
				else:
					trans_state(Player.State.BICYCLE)
			else:
				trans_state(Player.State.HEADER)	
		elif player.velocity != Vector2.ZERO:
			trans_state(Player.State.TACKLING)

func can_carry_ball() -> bool:
	return player.role != Player.Role.KEEPER

func can_teammate_pass_ball() -> bool:
	return ball.carrier != null and ball.carrier.team == player.team and ball.carrier.control_scheme == Player.ControlScheme.CPU

func can_pass() -> bool:
	return true
