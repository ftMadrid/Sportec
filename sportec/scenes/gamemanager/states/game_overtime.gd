class_name GameStateOvertime
extends GameState

func _enter_tree() -> void:
	GameEvents.teamScored.connect(teamScore.bind())
	print("overtime")

func teamScore(teamScored: String) -> void:
	manager.increaseScore(teamScored) 
	var data = GameStateData.build().setTeamScored(teamScored)
	transState(GameManager.State.GAMEOVER, data)
