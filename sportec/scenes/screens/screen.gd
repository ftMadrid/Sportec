class_name Screen
extends Node

signal screen_trans_req(new_screen: GamePreset.Screens, data: ScreenData)

var game : GamePreset = null
var screen_data : ScreenData = null

func setUp(manage_game: GamePreset, manage_data: ScreenData) -> void:
	game = manage_game
	screen_data = manage_data

func transScreen(new_screen: GamePreset.Screens, data: ScreenData = ScreenData.new()) -> void:
	screen_trans_req.emit(new_screen, data)
