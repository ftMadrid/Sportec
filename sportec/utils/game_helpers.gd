class_name GameHelpers

static var team_imgs : Dictionary[String, Texture2D] = {}

static func getScoreText(score: Array[int]) -> String:
	return "%d - %d" % [score[0], score[1]]

static func getTexture(team: String) -> Texture2D:
	if not team_imgs.has(team):
		team_imgs.set(team, load("res://assets/art/ui/teams/team-%s.png" % [team.to_lower()]))
	return team_imgs[team]

static func getTimeText(time_left: float, score: Array[int]) -> String:
	if time_left < 0 and score[0] == score[1]:
		return " OVERTIME!"
	elif time_left < 0:
		return " TIMES UP!"
	else:
		var minutes := int(time_left / 60.0)
		var seconds := time_left - minutes * 60
		return "%02d:%02d" % [minutes, seconds] 

static func getCurrentScoreInfo(teams: Array[String], score: Array[int]) -> String:
	if score[0] == score[1]:
		return "TEAMS ARE NOW TIED! [%d - %d]" % [score[0], score[1]]
	elif score[0] > score[1]:
		return "%s LEADS! [%d - %d]" % [teams[0], score[0], score[1]]
	else:
		return "%s LEADS! [%d - %d]" % [teams[1], score[1], score[0]]

static func getFinalScore(teams: Array[String], score: Array[int]) -> String:
	if score[0] > score[1]:
		return "%s WINS THE GAME! [%d - %d]" % [teams[0], score[0], score[1]]
	else:
		return "%s WINS THE GAME! [%d - %d]" % [teams[1], score[1], score[0]]
