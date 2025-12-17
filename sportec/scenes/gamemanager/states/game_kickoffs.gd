class_name GameStateKickoffs
extends GameState

var valid_ct_schemes := []
var kickoff_unlocked := false

func _enter_tree() -> void:
	var team_starting := state_data.teamScored
	if team_starting.is_empty():
		team_starting = manager.teams[0]

	if team_starting == manager.player_setup[0]:
		valid_ct_schemes.append(Player.ControlScheme.P1)
	if team_starting == manager.player_setup[1]:
		valid_ct_schemes.append(Player.ControlScheme.P2)

	if valid_ct_schemes.is_empty():
		valid_ct_schemes.append(Player.ControlScheme.P1)

func _physics_process(_delta: float) -> void:
	if not kickoff_unlocked:
		if not allPlayersReady():
			return
		kickoff_unlocked = true
		return

	for control_scheme in valid_ct_schemes:
		if KeyUtils.actionJustPressed(control_scheme, KeyUtils.Action.PASS):
			startKickoff()

func allPlayersReady() -> bool:
	for p in get_tree().get_nodes_in_group("players"):
		if not p.readyForKickoff():
			return false
	return true

func startKickoff() -> void:
	GameEvents.kickoff_started.emit()
	PlayerSound.playSound(PlayerSound.Sound.WHISTLE)
	transState(GameManager.State.PLAY)
