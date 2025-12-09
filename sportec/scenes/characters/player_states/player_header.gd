class_name PlayerStateHeader
extends PlayerState

const height_start := 0.1
const height_velocity := 2.0
const extra_power := 1.3
const height_min := 10.0
const height_max := 30.0

var is_landing := false

func _enter_tree() -> void:
	player_animation.play("header")
	player.height = height_start
	player.height_velocity = height_velocity
	ball_area.body_entered.connect(ball_entered.bind())
	is_landing = false

# just to make sure the ball move through the header process 
func ball_entered(tact_ball: Ball) -> void:
	if tact_ball.air_connect(height_min, height_max):
		tact_ball.shoot(player.velocity.normalized() * player.power * extra_power)

func _physics_process(_delta: float) -> void:
	# check if the player touch the ground
	if player.height == 0 and not is_landing:
		is_landing = true
		finish_fall()

# make a simple and pretty animation of falling
func finish_fall() -> void:
	await get_tree().create_timer(0.05).timeout
	
	# just to check if the node is still active
	if is_inside_tree():
		trans_state(Player.State.RECOVERING)
