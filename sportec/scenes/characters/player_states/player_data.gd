class_name PlayerStateData

var shoot_direction: Vector2
var shoot_power: float
var hurt_direction: Vector2
var pass_target: Player
var reset_pos: Vector2

static func build() -> PlayerStateData:
	return PlayerStateData.new()

func setShootDirection(direction: Vector2) -> PlayerStateData:
	shoot_direction = direction
	return self

func setShootPower(power: float) -> PlayerStateData:
	shoot_power = power
	return self

func setHurtDirection(dir: Vector2) -> PlayerStateData:
	hurt_direction = dir
	return self

func setPassTarget(player: Player) -> PlayerStateData:
	pass_target = player
	return self

func setResetPosition(position: Vector2) -> PlayerStateData:
	reset_pos = position
	return self
	
