extends Node

enum Action {LEFT, RIGHT, UP, DOWN, SHOOT, PASS}

const ACTIONS_MAP : Dictionary = {
	Player.ControlScheme.P1: {
		Action.LEFT: "p_left",
		Action.RIGHT: "p_right",
		Action.UP: "p_up",
		Action.DOWN: "p_down",
		Action.PASS: "p_pass",
		Action.SHOOT: "p_shoot",
	},
	Player.ControlScheme.P2: {
		Action.LEFT: "p2_left",
		Action.RIGHT: "p2_right",
		Action.UP: "p2_up",
		Action.DOWN: "p2_down",
		Action.PASS: "p2_pass",
		Action.SHOOT: "p2_shoot",
	},
}

func get_input_vector(scheme: Player.ControlScheme) -> Vector2:
	var map : Dictionary = ACTIONS_MAP[scheme]
	return Input.get_vector(map[Action.LEFT], map[Action.RIGHT], map[Action.UP], map[Action.DOWN])

func action_pressed(scheme: Player.ControlScheme, action: Action) -> bool:
	return Input.is_action_pressed(ACTIONS_MAP[scheme][action])

func action_just_pressed(scheme: Player.ControlScheme, action: Action) -> bool:
	return Input.is_action_just_pressed(ACTIONS_MAP[scheme][action])

func action_just_released(scheme: Player.ControlScheme, action: Action) -> bool:
	return Input.is_action_just_released(ACTIONS_MAP[scheme][action])	
