class_name GamePreset
extends Node

enum Screens {MAINMENU, TEAM_SELECTOR, TOURNAMENT, IN_GAME}

var current_screen : Screen = null
var screen_fact := ScreenFactory.new()

func _init() -> void:
	switchScreen(Screens.MAINMENU)

func switchScreen(screen: Screens, data: ScreenData = ScreenData.new()) -> void:
	if current_screen != null:
		current_screen.queue_free()
	current_screen = screen_fact.getScreen(screen)
	current_screen.setUp(self, data)
	current_screen.screen_trans_req.connect(switchScreen.bind())
	call_deferred("add_child", current_screen)
