class_name Actors
extends Node2D

const player_preload := preload("res://scenes/characters/player.tscn")

@export var ball: Ball
@export var frame_home : Goal
@export var frame_away : Goal
@export var home_team : String
@export var away_team : String

@onready var spawns : Node2D = %Ready

func _ready() -> void:
	spawn_players(home_team, frame_home)
	spawns.scale.x = -1
	spawn_players(away_team, frame_away)
	
	var player : Player = get_children().filter(func(p): return p is Player)[4]
	player.control_scheme = Player.ControlScheme.P1
	player.set_actual_target()

func spawn_players(team: String, own_frame: Goal) -> void:
	var players := Data.squad(team)
	var target_frame := frame_home if own_frame == frame_away else frame_away
	for i in players.size():
		var player_position := spawns.get_child(i).global_position as Vector2
		var player_data := players[i] as PlayerResources
		var player := spawn_player(player_position, own_frame, target_frame, player_data, team)
		add_child(player)

func spawn_player(player_position: Vector2, own_frame: Goal, target_frame: Goal, player_data: PlayerResources, team: String) -> Player:
	var player := player_preload.instantiate()
	player.loader(player_position, ball, own_frame, target_frame, player_data, team)
	return player
