class_name Ball
extends AnimatableBody2D

enum State {CARRIED, SHOOT, FREEFORM}

@export var air_fric : float = 35.0
@export var ground_fric : float = 250.0
@export var air_min_height : float = 10.0
@export var air_max_height : float = 30.0

@onready var player_animation : AnimationPlayer = %AnimationPlayer
@onready var detection_area : Area2D = %DetectionArea
@onready var ball_sprite : Sprite2D = %BallSprite

var state_fact := BallStateFactory.new()
var current_state : BallState = null
var carrier : Player = null
var velocity := Vector2.ZERO
var height := 0.0
var height_velocity := 0.0

func _ready() -> void:
	switch_st(State.FREEFORM)

func _physics_process(_delta: float) -> void:
	ball_sprite.position = Vector2.UP * height

func switch_st(state: Ball.State) -> void:
	if current_state != null:
		current_state.queue_free()
		
	current_state = state_fact.get_state(state)
	current_state.setup(self, detection_area, carrier, player_animation, ball_sprite)
	current_state.transition_state.connect(switch_st.bind())
	current_state.name = "| BallStateMachine" + str(state)
	call_deferred("add_child", current_state)

func shoot(shoot_velocity : Vector2) -> void:
	velocity = shoot_velocity
	carrier = null
	switch_st(Ball.State.SHOOT)

func pass_to(destination: Vector2) -> void:
	var direction := position.direction_to(destination)
	var distance := position.distance_to(destination)
	var intensity := sqrt(2 * distance * ground_fric)
	velocity = intensity * direction
	if distance > 130:
		height_velocity = BallState.gravity * distance / (1.8 * intensity) # equation to give a gravity effect to the pass ball
	carrier = null
	switch_st(Ball.State.FREEFORM)
	
func stop() -> void:
	velocity = Vector2.ZERO

func in_air_action() -> bool:
	return current_state != null and current_state.in_air_action()

func air_connect() -> bool:
	return height >= air_min_height and height <= air_max_height
