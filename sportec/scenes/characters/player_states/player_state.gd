class_name PlayerState
extends Node

signal transition_state(new_state: Player.State, state_data: PlayerStateData)

var player_animation : AnimationPlayer = null
var player : Player = null
var state_data : PlayerStateData = PlayerStateData.new()
var ball : Ball = null
var teammate_area : Area2D = null
var ball_area : Area2D = null

# setting up the player context to get her references (more simple to setup references)
func setup(manage_player: Player, manage_data: PlayerStateData, manage_player_animation: AnimationPlayer, 
manage_ball: Ball, manage_teammate_area: Area2D, manage_ball_area: Area2D) -> void:
	
	player = manage_player
	player_animation = manage_player_animation
	state_data = manage_data
	ball = manage_ball
	teammate_area = manage_teammate_area
	ball_area = manage_ball_area

# to control in a good way the states from the player
func trans_state(new_state: Player.State, data: PlayerStateData = PlayerStateData.new()) -> void:
	transition_state.emit(new_state, data)

func animation_complete() -> void:
	pass # override the original method from player.gd
