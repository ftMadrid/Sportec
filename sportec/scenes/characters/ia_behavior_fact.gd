class_name IABehaviorFact

var roles : Dictionary

func _init() -> void:
	roles = {
		Player.Role.KEEPER: IABehaviorKeeper,
		Player.Role.DEFENSE: IABehaviorField,
		Player.Role.MIDFIELD: IABehaviorField,
		Player.Role.ATTACK: IABehaviorField,
	}

func get_ia_behavior(role: Player.Role) -> IABehavior:
	assert(roles.has(role), " role doesnt exists!")
	return roles.get(role).new()
