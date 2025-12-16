class_name GameStateGameOver
extends GameState

func _enter_tree() -> void:
	MusicManager.stop_music()
	
	var team_winner := manager.getTeamWinner()
	GameEvents.gameover.emit(team_winner)
	PlayerSound.playSound(PlayerSound.Sound.WHISTLE)
	
	# here i register the result [I COMMENT BECAUSE I ALWAYS FORGOT TO UPDATE]
	if TournamentManager.player_team_name != "":
		var my_goals = 0
		var rivals_goals = 0
		
		if manager.teams[0] == TournamentManager.player_team_name:
			my_goals = manager.score[0]
			rivals_goals = manager.score[1]
		else:
			my_goals = manager.score[1]
			rivals_goals = manager.score[0]
		
		TournamentManager.registerPlayerResult(my_goals, rivals_goals)
	
	await get_tree().create_timer(4.0).timeout
	
	if manager.active_screen:
		manager.active_screen.transScreen(GamePreset.Screens.TOURNAMENT)
	else:
		# just if the past function in [IF] doesnt work
		get_tree().change_scene_to_file("res://scenes/screens/tournament_screen.tscn")
