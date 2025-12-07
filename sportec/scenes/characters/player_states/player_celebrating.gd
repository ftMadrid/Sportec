class_name PlayerStateCelebrating
extends PlayerState

func _enter_tree() -> void:
	celebrate()
	GameEvents.team_reset.connect(teamReset.bind())

func _physics_process(delta: float) -> void:
	if player.height == 0:
		celebrate()
	player.velocity = player.velocity.move_toward(Vector2.ZERO, delta * 35.0)

func celebrate() -> void:
	player_animation.play("celebration")
	player.height = 0.1
	player.height_velocity = 2.0

func teamReset() -> void:
	trans_state(Player.State.RESETING, PlayerStateData.build().setResetPosition(player.spawn_position))
