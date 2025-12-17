class_name BallStateData

var lock_duration : int

static func build() -> BallStateData:
	return BallStateData.new()

func setLockDuration(duration: int) -> BallStateData:
	lock_duration = duration
	return self
