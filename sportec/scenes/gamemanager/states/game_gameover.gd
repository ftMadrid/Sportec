class_name GameStateGameOver
extends GameState


func _enter_tree() -> void:
	MusicManager.stop_music()
	
	var team_winner := manager.getTeamWinner()
	GameEvents.gameover.emit(team_winner)
	PlayerSound.playSound(PlayerSound.Sound.WHISTLE)
	await get_tree().create_timer(5.0).timeout
	print("game over")
