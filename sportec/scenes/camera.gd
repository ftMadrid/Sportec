class_name Camera
extends Camera2D

const target_distance := 100.0
const smooth_ball_carrier := 2
const smooth_ball := 6

@export var ball : Ball

func _physics_process(_delta: float) -> void:
	if ball.carrier != null:
		position = ball.carrier.position + ball.carrier.heading * target_distance
		position_smoothing_speed = smooth_ball_carrier
	else:
		position = ball.position
		position_smoothing_speed = smooth_ball
