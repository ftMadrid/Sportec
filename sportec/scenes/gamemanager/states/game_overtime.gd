class_name GameStateOvertime
extends GameState

func _enter_tree() -> void:
	GameEvents.team_scored.connect(teamScore.bind())
	print("overtime")

func teamScore(team_scored: String) -> void:
	manager.increaseScore(team_scored) 
	var data = GameStateData.build().set_team_scored(team_scored)
	trans_state(GameManager.State.GAMEOVER, data)
