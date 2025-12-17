class_name GameStateData

var teamScored : String

static func build() -> GameStateData:
	return GameStateData.new()

func setTeamScored(team: String) -> GameStateData:
	teamScored = team
	return self
