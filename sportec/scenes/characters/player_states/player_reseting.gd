class_name PlayerStateReseting
extends PlayerState

var arrived := false
var default_mask : int

func _enter_tree() -> void:
	arrived = false
	default_mask = player.collision_mask
	player.collision_mask = 0
	player.modulate.a = 0.6

	GameEvents.kickoff_started.connect(kickoffStarted)

func _exit_tree() -> void:
	if GameEvents.kickoff_started.is_connected(kickoffStarted):
		GameEvents.kickoff_started.disconnect(kickoffStarted)

func _physics_process(_delta: float) -> void:
	if arrived:
		return

	var dir := player.position.direction_to(state_data.reset_pos)
	player.velocity = dir * player.speed
	player.setHeading()
	player.movementAnimation()

	if player.position.distance_to(state_data.reset_pos) < 5.0:
		stopConfirm()

func stopConfirm() -> void:
	arrived = true
	player.velocity = Vector2.ZERO

	player.movementAnimation()
	player.faceTargetGoal()

	player.position = state_data.reset_pos
	player.collision_mask = default_mask
	player.modulate.a = 1.0

func kickoffStarted() -> void:
	if not arrived:
		return

	transition_state.emit(Player.State.MOVING)

func readyForKickoff() -> bool:
	return arrived
