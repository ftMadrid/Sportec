class_name Actors
extends Node2D

const player_preload := preload("res://scenes/characters/player.tscn")
const spark_fab := preload("res://scenes/spark.tscn")
const weight_cache := 200

@export var ball: Ball
@export var frame_home : Goal
@export var frame_away : Goal
@onready var spawns : Node2D = %Ready
@onready var kickoffs : Node2D = %Kickoffs

var home_squad : Array[Player] = []
var away_squad : Array[Player] = []
var time_cache_refresh := Time.get_ticks_msec()
var check_kickoff_read := false

func _init() -> void:
	GameEvents.teamReset.connect(teamReset.bind())
	GameEvents.impact_received.connect(impactReceived.bind())

func _ready() -> void:
	home_squad = spawnPlayers(GameManager.teams[0], frame_home)
	frame_home.init(GameManager.teams[0])
	spawns.scale.x = -1
	kickoffs.scale.x = -1
	away_squad = spawnPlayers(GameManager.teams[1], frame_away)
	frame_away.init(GameManager.teams[1])
	
	setupControlScheme()
	GameManager.switchState(GameManager.State.RESET)
	MusicManager.playMusic("gameplay")

func _physics_process(_delta: float) -> void:
	if Time.get_ticks_msec() - time_cache_refresh > weight_cache:
		time_cache_refresh = Time.get_ticks_msec()
		setDutyWeights()
	if check_kickoff_read:
		checkKickOffRead()

func spawnPlayers(team: String, own_frame: Goal) -> Array[Player]:
	var player_nodes : Array[Player] = []
	var players := Data.squad(team)
	var target_frame := frame_home if own_frame == frame_away else frame_away
	
	for i in players.size():
		var player_position := spawns.get_child(i).global_position as Vector2
		var player_data := players[i] as PlayerResources
		var kickoff_pos := player_position
		if i > 3:
			kickoff_pos = kickoffs.get_child(i-4).global_position as Vector2
		var player := spawnPlayer(player_position, kickoff_pos, own_frame, target_frame, player_data, team)
		player_nodes.append(player)
		add_child(player)

	return player_nodes

func spawnPlayer(player_position: Vector2, kickoffs_pos: Vector2, own_frame: Goal, target_frame: Goal, player_data: PlayerResources, team: String) -> Player:
	var player : Player = player_preload.instantiate()
	player.setControlScheme(Player.ControlScheme.CPU) 
	player.loader(player_position, kickoffs_pos, ball,  own_frame, target_frame, player_data, team)
	player.swap_requested.connect(playerSwapRequest.bind())
	player.ball_possessed.connect(autoSwitchRequested.bind())
	return player

func autoSwitchRequested(new_carrier: Player) -> void:
	var squad_to_check : Array[Player] = []
	
	if home_squad.has(new_carrier):
		squad_to_check = home_squad
	elif away_squad.has(new_carrier):
		squad_to_check = away_squad
	
	if squad_to_check.is_empty(): return

	var current_p1 : Player = null
	
	for p in squad_to_check:
		if p.control_scheme == Player.ControlScheme.P1:
			current_p1 = p
			break
	
	if current_p1 and current_p1 != new_carrier:
		current_p1.setControlScheme(Player.ControlScheme.CPU)
		
		new_carrier.setControlScheme(Player.ControlScheme.P1)
		print("Auto-switch: P1 cambio de ", current_p1.pname, " a ", new_carrier.pname)

func setDutyWeights() -> void:
	for squad in [away_squad, home_squad]:
		var cpu_players : Array[Player] = squad.filter(
			func(p: Player): return p.control_scheme == Player.ControlScheme.CPU and p.role != Player.Role.KEEPER
		)
		cpu_players.sort_custom(func(p1: Player, p2: Player):
			return p1.spawn_position.distance_squared_to(ball.position) < p2.spawn_position.distance_squared_to(ball.position))
		
		for i in range(cpu_players.size()):
			cpu_players[i].weight_steering = 1 - ease(float(i)/10.0, 0.1)

func playerSwapRequest(requester: Player) -> void:
	var squad := home_squad if requester.team == home_squad[0].team else away_squad
	var cpu_players : Array[Player] = squad.filter(
			func(p: Player): return p.control_scheme == Player.ControlScheme.CPU and p.role != Player.Role.KEEPER
	)
	cpu_players.sort_custom(func(p1: Player, p2: Player):
		return p1.position.distance_squared_to(ball.position) < p2.position.distance_squared_to(ball.position))
	var closest_cpu_to_ball : Player = cpu_players[0]	
	if closest_cpu_to_ball.position.distance_squared_to(ball.position) < requester.position.distance_squared_to(ball.position):
		var player_control_scheme := requester.control_scheme
		requester.setControlScheme(Player.ControlScheme.CPU)
		closest_cpu_to_ball.setControlScheme(player_control_scheme)

func teamReset() -> void:
	check_kickoff_read = true

func checkKickOffRead() -> void:
	for team in [home_squad, away_squad]:
		for player : Player in team:
			if not player.readyForKickoff():
				return
	setupControlScheme()
	check_kickoff_read = false
	GameEvents.kickoff_ready.emit()

func setupControlScheme() -> void:
	print("=== Setting Up the Controls ===")
	# reset all the cpu
	for player in home_squad + away_squad:
		player.setControlScheme(Player.ControlScheme.CPU)
	
	var p1_team_name := GameManager.player_setup[0]
	print("| Team selected for P1: ", p1_team_name)
	print("| Local Team: ", home_squad[0].team)
	print("| Away Team:: ", away_squad[0].team)

	# assing controls [to prevent bugs]
	if GameManager.isCoop():
		var player_team := home_squad if home_squad[0].team == p1_team_name else away_squad
		# just to confirm that there is sufficient players
		if player_team.size() > 5:
			player_team[4].setControlScheme(Player.ControlScheme.P1)
			player_team[5].setControlScheme(Player.ControlScheme.P2)
			print("| Mode COOP: P1 set to ", player_team[4].name)
		else:
			print("| The team doesnt have the sufficient player to play COOP Mode!")

	elif GameManager.isSingle():
		var player_team = home_squad if home_squad[0].team == p1_team_name else away_squad
		
		# just to improve to dont have bugs in team selector
		if home_squad[0].team != p1_team_name and away_squad[0].team != p1_team_name:
			print("There is no team that is in the team selector!")
			player_team = home_squad

		if player_team.size() > 5:
			player_team[5].setControlScheme(Player.ControlScheme.P1)
			print("P1 set to ", player_team[0].team)
		else:
			# only if the array is smaller we take the last oone gg
			player_team.back().setControlScheme(Player.ControlScheme.P1)
			print("P2 set to ", player_team[0].team)

	else:
		# versus logic [develop for future versions]
		var p1_squad := home_squad if home_squad[0].team == p1_team_name else away_squad
		var p2_squad := home_squad if p1_squad == away_squad else away_squad
		
		if p1_squad.size() > 5 and p2_squad.size() > 5:
			p1_squad[5].setControlScheme(Player.ControlScheme.P1)
			p2_squad[5].setControlScheme(Player.ControlScheme.P2)

func impactReceived(impact_pos: Vector2, _high_impact: bool) -> void:
	var spark := spark_fab.instantiate()
	spark.position = impact_pos
	add_child(spark)
	
	
