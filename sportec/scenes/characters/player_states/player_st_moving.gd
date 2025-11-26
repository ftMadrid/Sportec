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
		
	if player.has_ball():
		if KeyUtils.action_just_pressed(player.control_scheme, KeyUtils.Action.PASS):
			trans_state(Player.State.PASSING)
		elif KeyUtils.action_just_pressed(player.control_scheme, KeyUtils.Action.SHOOT):
			trans_state(Player.State.PREP_SHOOT)
			
	elif ball.in_air_action() and KeyUtils.action_just_pressed(player.control_scheme, KeyUtils.Action.SHOOT):
		if player.velocity == Vector2.ZERO:
			if player.facing_target_goal():
				trans_state(Player.State.VOLLEY)
			else:
				trans_state(Player.State.BICYCLE)
		else:
			trans_state(Player.State.HEADER)
			
	elif player.velocity != Vector2.ZERO and KeyUtils.action_just_pressed(player.control_scheme, KeyUtils.Action.SHOOT):
		trans_state(Player.State.TACKLING)
