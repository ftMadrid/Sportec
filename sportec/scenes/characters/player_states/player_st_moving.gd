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
	
	if player.has_ball() and Input.is_action_just_pressed("p_shoot"):
		state_transition_requested.emit(Player.State.PREP_SHOOT)
