class_name GameStateData

var team_scored : String

static func build() -> GameStateData:
	return GameStateData.new()

func set_team_scored(team: String) -> GameStateData:
	team_scored = team
	return self
