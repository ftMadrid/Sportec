class_name PlayerStateSad
extends PlayerState

func _enter_tree() -> void:
	player_animation.play("sad")
	player.velocity = Vector2.ZERO
