class_name BallStateCarried
extends BallState

const offset_player := Vector2(9,4)
var dribble_freq := 10.0
var dribble_int := 4.0
var dribble_tm := 0.0

func _enter_tree() -> void:
	assert(carrier != null)

func _physics_process(delta: float) -> void:
	var vx := 0.0
	dribble_tm += delta
	
	if carrier.velocity != Vector2.ZERO:
		if carrier.velocity.x != 0:
			vx = cos(dribble_tm * dribble_freq) * dribble_int
		if carrier.heading.x >= 0:
			player_animation.play("rolling")
			player_animation.advance(0)
		else:
			player_animation.play_backwards("rolling")
			player_animation.advance(0)
	else:
		player_animation.play("idle")
	
	ball.position = carrier.position + Vector2(vx + carrier.heading.x * offset_player.x, offset_player.y)
