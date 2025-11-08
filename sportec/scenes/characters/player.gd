class_name Player
extends CharacterBody2D

enum ControlScheme {CPU, P1}
enum State {MOVING, TACKLING, RECOVERING, PREP_SHOOT, SHOOTING}

@export var control_scheme : ControlScheme
@export var speed : float = 100.0
@export var power : float = 80.0
@export var ball : Ball

@onready var player_animation: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $PlayerSprite

var current_state: PlayerState = null
var state_fact := PlayerStateFactory.new()
var heading := Vector2.RIGHT

func _physics_process(_delta: float) -> void:
	move_and_slide()
	
func _ready() -> void:
	switch_st(State.MOVING)
	
func switch_st(state: State) -> void:
	if current_state != null:
		current_state.queue_free()
		
	current_state = state_fact.get_state(state)
	current_state.setup(self, player_animation)
	current_state.state_transition_requested.connect(switch_st.bind())
	current_state.name = "| PlayerStateMachine: " + str(state)
	call_deferred("add_child", current_state)
	
func movement_animation() -> void:
	if velocity.length() > 0:
		player_animation.play("run")
	else:
		player_animation.play("idle")

func set_heading() -> void:
	if velocity.x > 0:
		heading = Vector2.RIGHT
		sprite.flip_h = false
	elif velocity.x < 0:
		heading = Vector2.LEFT
		sprite.flip_h = true

func has_ball() -> bool:
	return ball.carrier == self
		
	
