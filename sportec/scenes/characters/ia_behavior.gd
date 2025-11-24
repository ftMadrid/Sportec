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
	total_st_force += duty_steering()
	total_st_force = total_st_force.limit_length(1.0)
	player.velocity = total_st_force * player.speed

func ia_decisions() -> void:
	pass

func duty_steering() -> Vector2:
	return player.weight_steering * player.position.direction_to(ball.position)
