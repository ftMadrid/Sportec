class_name Player
extends CharacterBody2D

signal swap_requested(player: Player)
signal ball_possessed(player: Player)

const control_scheme_map : Dictionary = {
	ControlScheme.CPU: preload("res://assets/art/props/cpu.png"),
	ControlScheme.P1: preload("res://assets/art/props/1p.png"),
	ControlScheme.P2: preload("res://assets/art/props/2p.png"),
}

const teams := ["DEFAULT", "REALMADRID", "BARCELONA", "AC.MILAN", "BAYERNMUNICH", "INTER", "LIVERPOOL", "M.UNITED", "ARSENAL"]
const gravity := 6.0
const walk_anim := 0.5

enum ControlScheme {CPU, P1, P2}
enum State {MOVING, TACKLING, RECOVERING, PREP_SHOOT, PASSING, SHOOTING, 
			BICYCLE, VOLLEY, HEADER, CHEST_CONTROL, HURT, DIVING, CELEBRATING, SAD, RESETING}
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
@onready var particles: Node2D = %Particles
@onready var execute_particles: GPUParticles2D = %ExecuteParticles

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
var kickoff_pos := Vector2.ZERO
var was_carrying_ball := false

var pname := ""
var role := Player.Role.MIDFIELD
var skincolor := Player.SkinColor.MEDIUM

const SKIN_PALETTE = preload("res://assets/art/palettes/skin-colors-palette.png")
const TEAM_PALETTE = preload("res://assets/art/palettes/teams-color-palette.png")
const SHADER = preload("res://shaders/replace_color.gdshader")

func _physics_process(delta: float) -> void:
	spriteVisibility()
	processGravity(delta)
	move_and_slide()
	checkAutoSwitch()

func _ready() -> void:
	add_to_group("players")
	setActualTarget()
	flipSprites()
	setupIABehavior()
	applyCustomSkinAndTeam()
	damage_area.monitoring = role == Role.KEEPER
	tackle_area.body_entered.connect(tacklePlayer.bind())
	keeper_hands_collider.disabled = role != Role.KEEPER
	damage_area.body_entered.connect(tacklePlayer.bind())
	spawn_position = position
	GameEvents.teamScored.connect(onTeamScored.bind())
	GameEvents.gameover.connect(gameOver.bind())
	var init_pos := kickoff_pos if team == GameManager.teams[0] else spawn_position
	switchState(State.RESETING, PlayerStateData.build().setResetPosition(init_pos))

func checkAutoSwitch() -> void:
	var carrying_now = hasBall()
	
	if carrying_now and not was_carrying_ball:
		if control_scheme == ControlScheme.CPU:
			ball_possessed.emit(self)
			
	was_carrying_ball = carrying_now

func flipSprites() -> void:
	if heading == Vector2.RIGHT:
		sprite.flip_h = false
		tackle_area.scale.x = 1
		opponent_area.scale.x = 1
		particles.scale.x = 1
	elif heading == Vector2.LEFT:
		sprite.flip_h = true
		tackle_area.scale.x = -1
		opponent_area.scale.x = -1
		particles.scale.x = -1

func loader(player_position: Vector2, manage_kickoff_pos: Vector2, manage_ball: Ball, own_frame: Goal, 
			target_frame: Goal, player_data: PlayerResources, manage_team: String):
	
	position = player_position
	kickoff_pos = manage_kickoff_pos
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
func applyCustomSkinAndTeam() -> void:
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

func setupIABehavior() -> void:
	current_ia_behavior = ia_behavior_fact.getIABehavior(role)
	current_ia_behavior.setup(self, ball, opponent_area, teammate_area)
	current_ia_behavior.name = "IA Behavior"
	add_child(current_ia_behavior)

func switchState(state: State, state_data: PlayerStateData = PlayerStateData.new()) -> void:
	if current_state != null:
		current_state.queue_free()
		
	current_state = state_fact.getState(state)
	current_state.setup(self, state_data, player_animation, ball, teammate_area, ball_area, own_goal, target_goal, tackle_area, current_ia_behavior)
	current_state.transition_state.connect(switchState.bind())
	current_state.name = "| PlayerStateMachine: " + str(state)
	call_deferred("add_child", current_state)
	
func movementAnimation() -> void:
	var vel := velocity.length()
	
	if vel < 1:
		player_animation.play("idle")
	elif vel < speed * walk_anim:
		player_animation.play("walk")
	else:
		player_animation.play("run")

func setHeading() -> void:
	if velocity.x > 0:
		heading = Vector2.RIGHT
		sprite.flip_h = false
	elif velocity.x < 0:
		heading = Vector2.LEFT
		sprite.flip_h = true

func hasBall() -> bool:
	return ball.carrier == self

func animation_complete() -> void:
	if current_state != null:
		current_state.animation_complete()

func setActualTarget() -> void:
	if not control_sprite: return
	control_sprite.texture = control_scheme_map[control_scheme]

func spriteVisibility() -> void:
	control_sprite.visible = hasBall() or not control_scheme == ControlScheme.CPU
	execute_particles.emitting = velocity.length() == speed

func processGravity(delta: float) -> void:
	if height > 0 or height_velocity != 0:
		height_velocity -= gravity * delta
		height += height_velocity
	
		if height <= 0:
			height = 0
			height_velocity = 0
	
	sprite.position = Vector2.UP * height

func controlBall() -> void:
	if ball.height > 10.0:
		switchState(Player.State.CHEST_CONTROL)

func facingTargetGoal() -> bool:
	var dir_target_goal := position.direction_to(target_goal.position)
	return heading.dot(dir_target_goal) > 0 # return angle of the heading

func getHurt(hurt_pos: Vector2) -> void:
	switchState(Player.State.HURT, PlayerStateData.build().setHurtDirection(hurt_pos))

func tacklePlayer(player: Player) -> void:
	if player != self and player.team != team and player == ball.carrier:
		player.getHurt(position.direction_to(player.position))

func canCarryBall() -> bool:
	return current_state != null and current_state.canCarryBall()

func getPassReq(player: Player) -> void:
	if ball.carrier == self and current_state != null and current_state.canPass():
		switchState(Player.State.PASSING, PlayerStateData.build().setPassTarget(player))

func onTeamScored(team_on: String) -> void:
	if team == team_on:
		switchState(Player.State.SAD)
	else:
		switchState(Player.State.CELEBRATING)

func gameOver(winning_team: String) -> void:
	if team == winning_team:
		switchState(Player.State.CELEBRATING)
	else:
		switchState(Player.State.SAD)

func faceTargetGoal() -> void:
	if not facingTargetGoal():
		heading = heading * -1
		flipSprites()

func readyForKickoff() -> bool:
	return current_state != null and current_state.readyForKickoff()

func setControlScheme(scheme: ControlScheme) -> void:
	control_scheme = scheme
	setActualTarget()
