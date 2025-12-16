class_name PlayerStateReseting
extends PlayerState

var arrived := false
var default_mask : int

func _enter_tree() -> void:
	GameEvents.kickoff_started.connect(kickoffStarted.bind())
	
	default_mask = player.collision_mask
	player.collision_mask = 0 
	player.modulate.a = 0.6 

func _physics_process(_delta: float) -> void:
	if not arrived:
		var dir := player.position.direction_to(state_data.reset_pos)
		player.velocity = dir * player.speed
		player.set_heading()
		player.movement_animation()
		
		if player.position.distance_to(state_data.reset_pos) < 5.0:
			llegada_confirmada()

func llegada_confirmada() -> void:
	arrived = true
	player.velocity = Vector2.ZERO
	
	player.movement_animation() 
	
	player.face_target_goal()

	player.position = state_data.reset_pos 
	
	player.collision_mask = default_mask
	player.modulate.a = 1.0

func kickoffStarted() -> void:
	player.collision_mask = default_mask
	player.modulate.a = 1.0
	transition_state.emit(Player.State.MOVING)

func readyForKickoff() -> bool:
	return arrived
