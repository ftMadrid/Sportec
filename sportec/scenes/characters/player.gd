class_name Player
extends CharacterBody2D

signal swap_requested(player: Player)

const control_scheme_map : Dictionary = {
	ControlScheme.CPU: preload("res://assets/art/props/cpu.png"),
	ControlScheme.P1: preload("res://assets/art/props/1p.png"),
	ControlScheme.P2: preload("res://assets/art/props/2p.png"),
}

const teams := ["DEFAULT", "REAL MADRID", "BARCELONA", "AC MILAN", "BAYERN MUNICH", "INTER", "LIVERPOOL", "M. UNITED", "ARSENAL"]
const gravity := 6.0
const walk_anim := 0.5

enum ControlScheme {CPU, P1, P2}
enum State {MOVING, TACKLING, RECOVERING, PREP_SHOOT, PASSING, SHOOTING, 
			BICYCLE, VOLLEY, HEADER, CHEST_CONTROL, HURT, DIVING}
enum Role {KEEPER, DEFENSE, MIDFIELD, ATTACK}
enum SkinColor {LIGHT, MEDIUM, DARK}

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
@onready var tackle_area: Area2D = %TackleArea
@onready var opponent_area: Area2D = %OpponentArea
@onready var damage_area: Area2D = %DamageArea
@onready var keeper_hands_collider: CollisionShape2D = %KeeperHandsCollider

var current_state: PlayerState = null
var state_fact := PlayerStateFactory.new()
var heading := Vector2.RIGHT
var height := 0.0
var height_velocity := 0.0
var team := ""
var spawn_position := Vector2.ZERO
var weight_steering := 0.0
var ia_behavior_fact := IABehaviorFact.new()
var current_ia_behavior : IABehavior = null

var pname := ""
var role := Player.Role.MIDFIELD
var skincolor := Player.SkinColor.MEDIUM

const SKIN_PALETTE = preload("res://assets/art/palettes/skin-colors-palette.png")
const TEAM_PALETTE = preload("res://assets/art/palettes/teams-color-palette.png")
const SHADER = preload("res://shaders/replace_color.gdshader")

func _physics_process(delta: float) -> void:
	sprite_visibility()
	process_gravity(delta)
	move_and_slide()

func _ready() -> void:
	set_actual_target()
	flipt_sprites()
	setup_ia_behavior()
	switch_st(State.MOVING)
	apply_custom_skin_and_team()
	damage_area.monitoring = role == Role.KEEPER
	tackle_area.body_entered.connect(tackle_player.bind())
	keeper_hands_collider.disabled = role != Role.KEEPER
	damage_area.body_entered.connect(tackle_player.bind())
	spawn_position = position
	
func flipt_sprites() -> void:
	if heading == Vector2.RIGHT:
		sprite.flip_h = false
		tackle_area.scale.x = 1
		opponent_area.scale.x = 1
	elif heading == Vector2.LEFT:
		sprite.flip_h = true
		tackle_area.scale.x = -1
		opponent_area.scale.x = -1

func loader(player_position: Vector2, manage_ball: Ball, own_frame: Goal, 
			target_frame: Goal, player_data: PlayerResources, manage_team: String):
	
	position = player_position
	ball = manage_ball
	own_goal = own_frame
	target_goal = target_frame
	
	speed = player_data.speed
	power = player_data.power
	pname = player_data.name
	role = player_data.role
	skincolor = player_data.skincolor
	team = manage_team
	
	# pre-calc of the header
	heading = Vector2.LEFT if target_goal.position.x < position.x else Vector2.RIGHT

# function to apply all the shaders
func apply_custom_skin_and_team() -> void:
	if not sprite: return
	
	var mat = ShaderMaterial.new()
	mat.shader = SHADER
	
	sprite.material = mat
	
	mat.set_shader_parameter("skin_palette", SKIN_PALETTE)
	mat.set_shader_parameter("team_palette", TEAM_PALETTE)
	
	var team_idx = teams.find(team)
	if team_idx == -1:
		team_idx = 0
		
	mat.set_shader_parameter("team_color", int(team_idx)) 
	mat.set_shader_parameter("skin_color", int(skincolor))

func setup_ia_behavior() -> void:
	current_ia_behavior = ia_behavior_fact.get_ia_behavior(role)
	current_ia_behavior.setup(self, ball, opponent_area, teammate_area)
	current_ia_behavior.name = "IA Behavior"
	add_child(current_ia_behavior)

func switch_st(state: State, state_data: PlayerStateData = PlayerStateData.new()) -> void:
	if current_state != null:
		current_state.queue_free()
		
	current_state = state_fact.get_state(state)
	current_state.setup(self, state_data, player_animation, ball, teammate_area, ball_area, own_goal, target_goal, tackle_area, current_ia_behavior)
	current_state.transition_state.connect(switch_st.bind())
	current_state.name = "| PlayerStateMachine: " + str(state)
	call_deferred("add_child", current_state)
	
func movement_animation() -> void:
	var vel := velocity.length()
	
	if vel < 1:
		player_animation.play("idle")
	elif vel < speed * walk_anim:
		player_animation.play("walk")
	else:
		player_animation.play("run")

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

func facing_target_goal() -> bool:
	var dir_target_goal := position.direction_to(target_goal.position)
	return heading.dot(dir_target_goal) > 0 # return angle of the heading

func get_hurt(hurt_pos: Vector2) -> void:
	switch_st(Player.State.HURT, PlayerStateData.build().set_hurt_direction(hurt_pos))

func tackle_player(player: Player) -> void:
	if player != self and player.team != team and player == ball.carrier:
		player.get_hurt(position.direction_to(player.position))

func can_carry_ball() -> bool:
	return current_state != null and current_state.can_carry_ball()

func get_pass_req(player: Player) -> void:
	if ball.carrier == self and current_state != null and current_state.can_pass():
		switch_st(Player.State.PASSING, PlayerStateData.build().set_pas_target(player))
