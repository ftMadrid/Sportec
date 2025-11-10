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
	var dir := Input.get_vector("p_left", "p_right", "p_up", "p_down")
	player.velocity = dir * player.speed
	
	if player.velocity != Vector2.ZERO:
		teammate_area.rotation = player.velocity.angle()
		
	if player.has_ball() and Input.is_action_just_pressed("p_pass"): # checks if the player has the ball to make the pass
		trans_state(Player.State.PASSING)
	
	if player.has_ball() and Input.is_action_just_pressed("p_shoot"): # checks if the player has the ball to make the shoot
		trans_state(Player.State.PREP_SHOOT)
	
	if !player.has_ball() and Input.is_action_just_pressed("p_shoot"):
		trans_state(Player.State.TACKLING)
