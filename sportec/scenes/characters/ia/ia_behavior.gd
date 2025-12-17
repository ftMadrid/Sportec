class_name IABehavior
extends Node

const ia_tick := 200

var ball : Ball = null
var player : Player = null
var time_ia_tick := Time.get_ticks_msec()
var opponent_area : Area2D = null
var teammate_area : Area2D = null

func _ready() -> void:
	time_ia_tick = Time.get_ticks_msec() + randi_range(0, ia_tick)

func setup(manage_player: Player, manage_ball: Ball, manage_opponent_area: Area2D, manage_teammate_area: Area2D) -> void:
	player = manage_player
	ball = manage_ball
	opponent_area = manage_opponent_area
	teammate_area = manage_teammate_area

func processIA() -> void:
	if Time.get_ticks_msec() - time_ia_tick > ia_tick:
		time_ia_tick = Time.get_ticks_msec()
		iaMovement()
		iaDecisions()

func iaMovement() -> void:
	pass

func iaDecisions() -> void:
	pass

func bicircularWeight(position: Vector2, center_target: Vector2, inn_circle_radius: float, 
						inn_circle_weight: float, out_circle_radius: float, out_circle_weight: float) -> float:
	
	var dist_center := position.distance_to(center_target)
	if dist_center > out_circle_radius:
		return out_circle_weight
	elif dist_center < inn_circle_radius:
		return inn_circle_weight
	else:
		var dist_inn_radius := dist_center - inn_circle_radius
		var close_dist := out_circle_radius - inn_circle_radius
		return lerpf(inn_circle_weight, out_circle_weight, dist_inn_radius / close_dist)

func ballCarriedByTeammate() -> bool:
	return ball.carrier != null and ball.carrier != player and ball.carrier.team == player.team

func ballPossessedByOpponent() -> bool:
	return ball.carrier != null and ball.carrier.team != player.team

func nearbyOpponents() -> bool:
	var players := opponent_area.get_overlapping_bodies()
	return players.find_custom(func(p: Player): return p.team != player.team) > -1

func ballProximityForce() -> Vector2:
	var weight := bicircularWeight(player.position, ball.position, 50, 1, 120, 0)
	var dir := player.position.direction_to(ball.position)
	return weight * dir

func getSpawnForce() -> Vector2:
	var weight := bicircularWeight(player.position, player.spawn_position, 30, 0, 100, 1)
	var dir := player.position.direction_to(player.spawn_position)
	return weight * dir

func hasTeammateView() -> bool:
	var players_view := teammate_area.get_overlapping_bodies()
	return players_view.find_custom(func(p: Player): return p != player and p.team == player.team) > -1
