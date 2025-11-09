class_name BallState
extends Node

signal state_transition_requested(new_state: BallState)

var ball : Ball = null
var detection_area : Area2D = null
var carrier : Player = null
var player_animation : AnimationPlayer = null
var bsprite : Sprite2D = null

func setup(manage_ball: Ball, manage_detection_area: Area2D, manage_carrier: Player, manage_player_animation: AnimationPlayer, manage_ball_sprite: Sprite2D ) -> void:
	ball = manage_ball
	detection_area = manage_detection_area
	player_animation = manage_player_animation
	carrier = manage_carrier
	bsprite = manage_ball_sprite
