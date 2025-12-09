class_name GameStateGameOver
extends GameState

func _enter_tree() -> void:
	var team_winner := manager.getTeamWinner()
	GameEvents.gameover.emit(team_winner)
	print("game over")
