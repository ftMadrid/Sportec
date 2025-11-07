class_name Ball
extends AnimatableBody2D

enum State {CARRIED, SHOOT, FREEFORM}

@onready var detection_area : Area2D = %DetectionArea

var state_fact := BallStateFactory.new()
var current_state : BallState = null
var carrier : Player = null
var velocity := Vector2.ZERO

func _ready() -> void:
	switch_st(State.FREEFORM)

func switch_st(state: Ball.State) -> void:
	if current_state != null:
		current_state.queue_free()
		
	current_state = state_fact.get_state(state)
	current_state.setup(self, detection_area, carrier)
	current_state.state_transition_requested.connect(switch_st.bind())
	current_state.name = "| BallStateMachine" + str(state)
	call_deferred("add_child", current_state)
