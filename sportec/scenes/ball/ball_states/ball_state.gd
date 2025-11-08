class_name BallState
extends Node

signal state_transition_requested(new_state: BallState)

var ball : Ball = null
var detection_area : Area2D = null
var carrier : Player = null
var player_animation : AnimationPlayer = null

func setup(context_ball: Ball, context_detection_area: Area2D, context_carrier: Player, context_player_animation: AnimationPlayer) -> void:
	ball = context_ball
	detection_area = context_detection_area
	carrier = context_carrier
	player_animation = context_player_animation
