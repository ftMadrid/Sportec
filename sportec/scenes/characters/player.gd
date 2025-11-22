class_name Player
extends CharacterBody2D

const control_scheme_map : Dictionary = {
	ControlScheme.CPU: preload("res://assets/art/props/cpu.png"),
	ControlScheme.P1: preload("res://assets/art/props/1p.png"),
	ControlScheme.P2: preload("res://assets/art/props/2p.png"),
}

const gravity := 6.0

enum ControlScheme {CPU, P1, P2}
enum State {MOVING, TACKLING, RECOVERING, PREP_SHOOT, PASSING, SHOOTING, 
			BICYCLE, VOLLEY, HEADER, CHEST_CONTROL}

@export var control_scheme : ControlScheme
@export var speed : float = 100.0
@export var power : float = 80.0
@export var ball : Ball
@export var own_goal : Goal
@export var target_goal : Goal

@onready var player_animation: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $PlayerSprite
@onready var teammate_area: Area2D = %TeammateArea
@onready var control_sprite: Sprite2D = %ControlSprite
@onready var ball_area: Area2D = %BallArea

var current_state: PlayerState = null
var state_fact := PlayerStateFactory.new()
var heading := Vector2.RIGHT
var height := 0.0
var height_velocity := 0.0

func _physics_process(delta: float) -> void:
	#sprite_visibility() DISABLED FOR NOW, ONLY TESTING
	process_gravity(delta)
	move_and_slide()
	
func _ready() -> void:
	set_actual_target()
	switch_st(State.MOVING)
	
func switch_st(state: State, state_data: PlayerStateData = PlayerStateData.new()) -> void:
	if current_state != null:
		current_state.queue_free()
		
	current_state = state_fact.get_state(state)
	current_state.setup(self, state_data, player_animation, ball, teammate_area, ball_area, own_goal, target_goal)
	current_state.transition_state.connect(switch_st.bind())
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

func animation_complete() -> void:
	if current_state != null:
		current_state.animation_complete()

func set_actual_target() -> void:
	control_sprite.texture = control_scheme_map[control_scheme]

func sprite_visibility() -> void:
	control_sprite.visible = has_ball() or not control_scheme == ControlScheme.CPU

func process_gravity(delta: float) -> void:
	if height > 0 or height_velocity != 0:
		height_velocity -= gravity * delta
		height += height_velocity
	
		if height <= 0:
			height = 0
			height_velocity = 0
	
	sprite.position = Vector2.UP * height

func control_ball() -> void:
	if ball.height > 10.0:
		switch_st(Player.State.CHEST_CONTROL)
