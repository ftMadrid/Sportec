class_name PlayerState
extends Node

signal state_transition_requested(new_state: Player.State)

var player_animation : AnimationPlayer = null
var player : Player = null

func setup(context_player: Player, context_player_animation: AnimationPlayer) -> void:
	player = context_player
	player_animation = context_player_animation
