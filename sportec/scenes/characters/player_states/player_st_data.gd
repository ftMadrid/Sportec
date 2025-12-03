class_name PlayerStateData

var shoot_direction: Vector2
var shoot_power: float
var hurt_direction: Vector2
var pass_target: Player

static func build() -> PlayerStateData:
	return PlayerStateData.new()

func set_shoot_direction(direction: Vector2) -> PlayerStateData:
	shoot_direction = direction
	return self

func set_shoot_power(power: float) -> PlayerStateData:
	shoot_power = power
	return self

func set_hurt_direction(dir: Vector2) -> PlayerStateData:
	hurt_direction = dir
	return self

func set_pas_target(player: Player) -> PlayerStateData:
	pass_target = player
	return self
