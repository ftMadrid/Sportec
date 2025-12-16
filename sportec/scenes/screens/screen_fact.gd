class_name ScreenFactory

var screens : Dictionary

func _init() -> void:
	screens = {
		GamePreset.Screens.IN_GAME: preload("res://scenes/screens/field/field.tscn"),
		GamePreset.Screens.MAINMENU: preload("res://scenes/screens/mainmenu.tscn"),
		GamePreset.Screens.TEAM_SELECTOR: preload("res://scenes/screens/team_selector.tscn"),
		GamePreset.Screens.TOURNAMENT: preload("res://scenes/screens/tournament_screen.tscn"),
		GamePreset.Screens.WINNER: preload("res://scenes/screens/winner_screen.tscn"),
	}

func getScreen(screen: GamePreset.Screens) -> Screen:
	assert(screens.has(screen), " that screen doesnt exists!")
	return screens.get(screen).instantiate()
