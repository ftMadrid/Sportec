class_name PlayerStateMoving
extends PlayerState

func _physics_process(_delta: float) -> void:
	if player.control_scheme == Player.ControlScheme.CPU:
		ia_behavior.processIA()
	else:
		handleHumanMoves()
		
	player.movementAnimation()
	player.setHeading()
	
func handleHumanMoves() -> void:
	var dir := KeyUtils.getInputVector(player.control_scheme)
	player.velocity = dir * player.speed
	
	if player.velocity != Vector2.ZERO:
		teammate_area.rotation = player.velocity.angle()
		
	if KeyUtils.actionJustPressed(player.control_scheme, KeyUtils.Action.PASS):
		if player.hasBall():
			transState(Player.State.PASSING)
		elif canTeammatePassBall():
			ball.carrier.getPassReq(player)
		else:
			player.swap_requested.emit(player)
	
	elif KeyUtils.actionJustPressed(player.control_scheme, KeyUtils.Action.SHOOT):
		if player.hasBall():
			transState(Player.State.PREP_SHOOT)
		elif ball.inAirAction():
			if player.velocity == Vector2.ZERO:
				if player.facingTargetGoal():
					transState(Player.State.VOLLEY)
				else:
					transState(Player.State.BICYCLE)
			else:
				transState(Player.State.HEADER)	
		elif player.velocity != Vector2.ZERO:
			transState(Player.State.TACKLING)

func canCarryBall() -> bool:
	return player.role != Player.Role.KEEPER

func canTeammatePassBall() -> bool:
	return ball.carrier != null and ball.carrier.team == player.team and ball.carrier.control_scheme == Player.ControlScheme.CPU

func canPass() -> bool:
	return true
