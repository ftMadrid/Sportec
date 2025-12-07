class_name PlayerStateReseting
extends PlayerState

var arrived := false

func _enter_tree() -> void:
	GameEvents.kickoff_started.connect(kickoffStarted.bind())

func _physics_process(_delta: float) -> void:
	if not arrived:
		var dir := player.position.direction_to(state_data.reset_pos)
		if player.position.distance_to(state_data.reset_pos) < 2:
			arrived = true
			player.velocity = Vector2.ZERO
			player.face_target_goal()
		else:
			player.velocity = dir * player.speed
		player.movement_animation()
		player.set_heading()

func readyForKickoff() -> bool:
	return arrived

func kickoffStarted() -> void:
	trans_state(Player.State.MOVING)
