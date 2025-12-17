class_name PlayerStateSad
extends PlayerState

func _enter_tree() -> void:
	player_animation.play("sad")
	player.velocity = Vector2.ZERO
	GameEvents.teamReset.connect(teamReset.bind())

func teamReset() -> void:
	transState(Player.State.RESETING, PlayerStateData.build().setResetPosition(player.kickoff_pos))
