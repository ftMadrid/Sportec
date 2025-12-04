extends Node

const game_duration := 2*60

enum State {PLAY, SCORED, RESET, KICKOFF, OVERTIME, GAMEOVER}

var time_left : float
var teams : Array[String] = ["REAL MADRID", "BARCELONA"]
var score := [0, 0]
var state_fact := GameStateFactory.new()
var current_state : GameState = null

func _ready() -> void:
	time_left = game_duration
	switch_st(State.PLAY)

func switch_st(state: State, data: GameStateData = GameStateData.new()) -> void:
	if current_state != null:
		current_state.queue_free()
	current_state = state_fact.get_fresh_state(state)
	current_state.setup(self, data)
	current_state.transition_state.connect(switch_st.bind())
	current_state.name = "| GameStateMachine: " + str(state)
	call_deferred("add_child", current_state)
