class_name PlayerStateChest
extends PlayerState

const duration_control := 300

var time_control := Time.get_ticks_msec()

func _enter_tree() -> void:
	player_animation.play("chest_control")
	player.velocity = Vector2.ZERO # to prevent the player move during the control
	time_control = Time.get_ticks_msec()

func _physics_process(_delta: float) -> void:
	if Time.get_ticks_msec() - time_control > duration_control:
		trans_state(Player.State.MOVING)
