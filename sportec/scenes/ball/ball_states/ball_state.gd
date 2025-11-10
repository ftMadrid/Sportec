class_name BallState
extends Node

signal transition_state(new_state: BallState) # signal to all (dictionary)

const gravity := 10.0

var ball : Ball = null
var detection_area : Area2D = null
var carrier : Player = null
var player_animation : AnimationPlayer = null
var bsprite : Sprite2D = null

# manage ball statements features
func setup(manage_ball: Ball, manage_detection_area: Area2D, manage_carrier: Player, manage_player_animation: AnimationPlayer, manage_ball_sprite: Sprite2D ) -> void:
	ball = manage_ball
	detection_area = manage_detection_area
	player_animation = manage_player_animation
	carrier = manage_carrier
	bsprite = manage_ball_sprite

# making looks pretty while ball's velocity is comming to 0
func set_ball_animation_velocity() -> void:
	if ball.velocity == Vector2.ZERO:
		player_animation.play("idle")
	elif ball.velocity.x > 0:
		player_animation.play("rolling")
		player_animation.advance(0)
	else:
		player_animation.play_backwards("rolling")
		player_animation.advance(0)

# adding the gravity process to the ball
func gravity_process(delta: float, rebound: float = 0.0) -> void:
	if ball.height > 0 or ball.height_velocity > 0:
		ball.height_velocity -= gravity * delta
		ball.height += ball.height_velocity
		if ball.height < 0: # just to make sure that the ball has to be on the ground
			ball.height = 0
			if rebound > 0 and ball.height_velocity < 0: # adding the rebound checking 
				ball.height_velocity = -ball.height_velocity * rebound
				ball.velocity = ball.velocity * rebound
