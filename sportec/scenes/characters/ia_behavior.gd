class_name IABehavior
extends Node

const ia_tick := 200

var ball : Ball = null
var player : Player = null
var time_ia_tick := Time.get_ticks_msec()

func _ready() -> void:
	time_ia_tick = Time.get_ticks_msec() + randi_range(0, ia_tick)

func setup(manage_player: Player, manage_ball: Ball) -> void:
	player = manage_player
	ball = manage_ball

func process_ia() -> void:
	if Time.get_ticks_msec() - time_ia_tick > ia_tick:
		time_ia_tick = Time.get_ticks_msec()
		ia_movement()
		ia_decisions()

func ia_movement() -> void:
	var total_st_force := Vector2.ZERO
	if player.has_ball():
		total_st_force += carrier_steering_force()
	elif player.role != Player.Role.KEEPER:
		total_st_force += duty_steering()
		if ball_carried_by_teammate():
			total_st_force += assist_formation_st()
	total_st_force = total_st_force.limit_length(1.0)
	player.velocity = total_st_force * player.speed

func ia_decisions() -> void:
	if ball.carrier == player:
		var target := player.target_goal.center_target_position()
		if player.position.distance_to(target) < 150 and randf() < 0.3:
			face_target_goal()
			var shoot_dir := player.position.direction_to(player.target_goal.random_target_position())
			var data := PlayerStateData.build().set_shoot_power(player.power).set_shoot_direction(shoot_dir)
			player.switch_st(Player.State.SHOOTING, data)

func duty_steering() -> Vector2:
	return player.weight_steering * player.position.direction_to(ball.position)

func carrier_steering_force() -> Vector2:
	var target := player.target_goal.center_target_position()
	var dir := player.position.direction_to(target)
	var weight := bicircular_weight(player.position, target, 100, 0, 150, 1)
	return weight * dir

func bicircular_weight(position: Vector2, center_target: Vector2, inn_circle_radius: float, 
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

func assist_formation_st() -> Vector2:
	var spawn_diff := ball.carrier.spawn_position - player.spawn_position
	var assist_dest := ball.carrier.position - spawn_diff * 0.8
	var dir := player.position.direction_to(assist_dest)
	var weight := bicircular_weight(player.position, assist_dest, 30, 0.2, 60, 1)
	return weight * dir

func ball_carried_by_teammate() -> bool:
	return ball.carrier != null and ball.carrier != player and ball.carrier.team == player.team

func face_target_goal() -> void:
	if not player.facing_target_goal():
		player.heading = player.heading * -1
