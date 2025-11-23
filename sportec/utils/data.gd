extends Node

# string = name, array = players
var squads : Dictionary[String, Array]

func _init() -> void:
	var json_file := FileAccess.open("res://assets/json/squads.json", FileAccess.READ) # just to read the file
	if json_file == null:
		printerr("| We cannot load the squads.json")
	
	var json_text := json_file.get_as_text()
	var json := JSON.new()
	
	# to parse and use different type of variable in a same .json
	if json.parse(json_text) != OK:
		printerr("| We cannot parse the squads.json")
	
	# loading data for the file
	for team in json.data:
		var team_name := team["team"] as String
		var players := team["players"] as Array
	
		if not squads.has(team_name):
			squads.set(team_name, [])
		
		for player in players:
			var pname := player["name"] as String
			var skin := player["skin"] as Player.SkinColor
			var role := player["role"] as Player.Role
			var speed := player["speed"] as float
			var power := player["power"] as float
			var resources := PlayerResources.new(pname, skin, role, speed, power)
			squads.get(team_name).append(resources) # pushing data
		assert(players.size() == 6) # to make sure 6 players per squad
	json_file.close() # c++ practices makes perfect yeah

func squad(team: String) -> Array:
	if squads.has(team):
		return squads[team]
	return []
