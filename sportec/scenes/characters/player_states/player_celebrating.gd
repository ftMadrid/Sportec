class_name PlayerStateCelebrating
extends PlayerState

var init_delay := randi_range(200, 800)
var celebrating_time := Time.get_ticks_msec()

func _enter_tree() -> void:
	GameEvents.teamReset.connect(teamReset.bind())

func _physics_process(delta: float) -> void:
	if player.height == 0 and Time.get_ticks_msec() - celebrating_time > init_delay:
		celebrate()
	player.velocity = player.velocity.move_toward(Vector2.ZERO, delta * 50.0)

func celebrate() -> void:
	player_animation.play("celebration")
	player.height = 0.1
	player.height_velocity = 2.0

func teamReset() -> void:
	transState(Player.State.RESETING, PlayerStateData.build().setResetPosition(player.spawn_position))
