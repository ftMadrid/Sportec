class_name GameState
extends Node

signal transition_state(new_state: GameManager.State, data: GameStateData)

var manager : GameManager = null
var state_data : GameStateData = null

func setup(manage_manager: GameManager, manage_data: GameStateData) -> void:
	manager = manage_manager
	state_data = manage_data

func transState(new_state: GameManager.State, data: GameStateData = GameStateData.new()) -> void:
	transition_state.emit(new_state, data)
