class_name GameStateKickoffs
extends GameState

var valid_ct_shames := []

func _enter_tree() -> void:
	var team_starting := state_data.teamScored
	if team_starting.is_empty():
		team_starting = manager.teams[0]
	if team_starting == manager.player_setup[0]:
		valid_ct_shames.append(Player.ControlScheme.P1)
	if team_starting == manager.player_setup[1]:
		valid_ct_shames.append(Player.ControlScheme.P2)
	if valid_ct_shames.size() == 0:
		valid_ct_shames.append(Player.ControlScheme.P1)

func _physics_process(_delta: float) -> void:
	for control_scheme : Player.ControlScheme in valid_ct_shames:
		if KeyUtils.actionJustPressed(control_scheme, KeyUtils.Action.PASS):
			GameEvents.kickoff_started.emit()
			PlayerSound.playSound(PlayerSound.Sound.WHISTLE)
			transState(GameManager.State.PLAY)
