class_name Actors
extends Node2D

const player_preload := preload("res://scenes/characters/player.tscn")
const weight_cache := 200

@export var ball: Ball
@export var frame_home : Goal
@export var frame_away : Goal

@onready var spawns : Node2D = %Ready

var home_squad : Array[Player] = []
var away_squad : Array[Player] = []
var time_cache_refresh := Time.get_ticks_msec()

func _ready() -> void:
	
	home_squad = spawn_players(GameManager.teams[0], frame_home)
	frame_home.init(GameManager.teams[0])
	spawns.scale.x = -1
	away_squad = spawn_players(GameManager.teams[1], frame_away)
	frame_away.init(GameManager.teams[1])
	
	var player : Player = get_children().filter(func(p): return p is Player)[4]
	player.control_scheme = Player.ControlScheme.P1
	player.set_actual_target()
	
	var player2 : Player = get_children().filter(func(p): return p is Player)[3]
	player2.control_scheme = Player.ControlScheme.P2
	player2.set_actual_target()

func _physics_process(_delta: float) -> void:
	if Time.get_ticks_msec() - time_cache_refresh > weight_cache:
		time_cache_refresh = Time.get_ticks_msec()
		set_duty_weights()

func spawn_players(team: String, own_frame: Goal) -> Array[Player]:
	var player_nodes : Array[Player] = []
	var players := Data.squad(team)
	var target_frame := frame_home if own_frame == frame_away else frame_away
	
	for i in players.size():
		var player_position := spawns.get_child(i).global_position as Vector2
		var player_data := players[i] as PlayerResources
		var player := spawn_player(player_position, own_frame, target_frame, player_data, team)
		player_nodes.append(player)
		add_child(player)

	return player_nodes

func spawn_player(player_position: Vector2, own_frame: Goal, target_frame: Goal, player_data: PlayerResources, team: String) -> Player:
	var player : Player = player_preload.instantiate()
	player.loader(player_position, ball, own_frame, target_frame, player_data, team)
	player.swap_requested.connect(player_swap_request.bind())
	return player

func set_duty_weights() -> void:
	for squad in [away_squad, home_squad]:
		var cpu_players : Array[Player] = squad.filter(
			func(p: Player): return p.control_scheme == Player.ControlScheme.CPU and p.role != Player.Role.KEEPER
		)
		cpu_players.sort_custom(func(p1: Player, p2: Player):
			return p1.spawn_position.distance_squared_to(ball.position) < p2.spawn_position.distance_squared_to(ball.position))
		
		for i in range(cpu_players.size()):
			cpu_players[i].weight_steering = 1 - ease(float(i)/10.0, 0.1)

func player_swap_request(requester: Player) -> void:
	var squad := home_squad if requester.team == home_squad[0].team else away_squad
	var cpu_players : Array[Player] = squad.filter(
			func(p: Player): return p.control_scheme == Player.ControlScheme.CPU and p.role != Player.Role.KEEPER
	)
	cpu_players.sort_custom(func(p1: Player, p2: Player):
		return p1.position.distance_squared_to(ball.position) < p2.position.distance_squared_to(ball.position))
	var closest_cpu_to_ball : Player = cpu_players[0]	
	if closest_cpu_to_ball.position.distance_squared_to(ball.position) < requester.position.distance_squared_to(ball.position):
		var player_control_scheme := requester.control_scheme
		requester.control_scheme = Player.ControlScheme.CPU
		requester.set_actual_target()
		closest_cpu_to_ball.control_scheme = player_control_scheme
		closest_cpu_to_ball.set_actual_target()
