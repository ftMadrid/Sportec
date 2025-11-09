class_name Ball
extends AnimatableBody2D

enum State {CARRIED, SHOOT, FREEFORM}

@onready var player_animation : AnimationPlayer = %AnimationPlayer
@onready var detection_area : Area2D = %DetectionArea
@onready var ball_sprite : Sprite2D = %BallSprite

var state_fact := BallStateFactory.new()
var current_state : BallState = null
var carrier : Player = null
var velocity := Vector2.ZERO
var height := 0.0

func _ready() -> void:
	switch_st(State.FREEFORM)

func _physics_process(_delta: float) -> void:
	ball_sprite.position = Vector2.UP * height

func switch_st(state: Ball.State) -> void:
	if current_state != null:
		current_state.queue_free()
		
	current_state = state_fact.get_state(state)
	current_state.setup(self, detection_area, carrier, player_animation, ball_sprite)
	current_state.state_transition_requested.connect(switch_st.bind())
	current_state.name = "| BallStateMachine" + str(state)
	call_deferred("add_child", current_state)

func shoot(shoot_velocity : Vector2) -> void:
	velocity = shoot_velocity
	carrier = null
	switch_st(Ball.State.SHOOT)
