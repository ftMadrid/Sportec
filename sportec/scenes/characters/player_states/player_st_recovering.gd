class_name PlayerStateRecovering
extends PlayerState

const recovery_duration := 500

var start_recovery := Time.get_ticks_msec()

func _enter_tree() -> void:
	player.velocity = Vector2.ZERO
	player_animation.play("recovery")

func _physics_process(_delta: float) -> void:
	if Time.get_ticks_msec() - start_recovery > recovery_duration:
		state_transition_requested.emit(Player.State.MOVING)
