class_name Camera
extends Camera2D

const target_distance := 100.0
const smooth_ball_carrier := 2
const smooth_ball := 6
const duration_shake := 120
const shake_intensity := 5

var shake_time := Time.get_ticks_msec()
var shaking := false

@export var ball : Ball

func _init() -> void:
	GameEvents.impact_received.connect(impactReceived.bind())

func _physics_process(_delta: float) -> void:
	if ball.carrier != null:
		position = ball.carrier.position + ball.carrier.heading * target_distance
		position_smoothing_speed = smooth_ball_carrier
	else:
		position = ball.position
		position_smoothing_speed = smooth_ball
	
	if shaking and Time.get_ticks_msec() - shake_time < duration_shake:
		offset = Vector2(randf_range(-shake_intensity, shake_intensity), randf_range(-shake_intensity, shake_intensity))
	else:
		shaking = false
		offset = Vector2.ZERO

func impactReceived(_impact_pos: Vector2, high_impact: bool) -> void:
	if high_impact:
		shaking = true
		shake_time = Time.get_ticks_msec()
	
