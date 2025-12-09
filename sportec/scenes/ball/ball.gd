class_name Ball
extends AnimatableBody2D

enum State {CARRIED, SHOOT, FREEFORM}

@export var air_fric : float = 35.0
@export var ground_fric : float = 250.0

@onready var player_animation : AnimationPlayer = %AnimationPlayer
@onready var detection_area : Area2D = %DetectionArea
@onready var ball_sprite : Sprite2D = %BallSprite
@onready var scoring_raycast : RayCast2D = %ScoringRayCast
@onready var shoot_particles : GPUParticles2D = %ShootParticles
@onready var player_proximity : Area2D = %PlayerProximity

var state_fact := BallStateFactory.new()
var current_state : BallState = null
var carrier : Player = null
var velocity := Vector2.ZERO
var height := 0.0
var height_velocity := 0.0
var spawn_pos := Vector2.ZERO

func _ready() -> void:
	switch_st(State.FREEFORM)
	spawn_pos = position
	GameEvents.team_reset.connect(team_reset.bind())
	GameEvents.kickoff_started.connect(kickoffStarted.bind())

func _physics_process(_delta: float) -> void:
	ball_sprite.position = Vector2.UP * height
	scoring_raycast.rotation = velocity.angle()

func switch_st(state: Ball.State, data: BallStateData = BallStateData.new()) -> void:
	if current_state != null:
		current_state.queue_free()
		
	current_state = state_fact.get_state(state)
	current_state.setup(self, data, detection_area, carrier, player_animation, ball_sprite, shoot_particles)
	current_state.transition_state.connect(switch_st.bind())
	current_state.name = "| BallStateMachine" + str(state)
	call_deferred("add_child", current_state)

func shoot(shoot_velocity : Vector2) -> void:
	velocity = shoot_velocity
	carrier = null
	switch_st(Ball.State.SHOOT)

func pass_to(destination: Vector2, lock_duration: int = 500) -> void:
	var direction := position.direction_to(destination)
	var distance := position.distance_to(destination)
	var intensity := sqrt(2 * distance * ground_fric)
	velocity = intensity * direction
	if distance > 130:
		height_velocity = BallState.gravity * distance / (1.8 * intensity) # equation to give a gravity effect to the pass ball
	carrier = null
	switch_st(Ball.State.FREEFORM, BallStateData.build().set_lock_duration(lock_duration))
	
func stop() -> void:
	velocity = Vector2.ZERO

func in_air_action() -> bool:
	return current_state != null and current_state.in_air_action()

func air_connect(air_min_height: float, air_max_height: float) -> bool:
	return height >= air_min_height and height <= air_max_height

func tumble(tumble_velocity: Vector2) -> void:
	velocity = tumble_velocity
	carrier = null
	height_velocity = 3.0
	switch_st(Ball.State.FREEFORM, BallStateData.build().set_lock_duration(200))

func headed_scoring_are(scoring_area: Area2D) -> bool:
	if not scoring_raycast.is_colliding():
		return false
	return scoring_raycast.get_collider() == scoring_area

func team_reset() -> void:
	position = spawn_pos
	velocity = Vector2.ZERO
	switch_st(State.FREEFORM)

func kickoffStarted() -> void:
	pass_to(spawn_pos + Vector2.DOWN * 30.0)

func getProximityTeammates(team: String) -> int:
	var players := player_proximity.get_overlapping_bodies()
	return players.filter(func(p: Player): return p.team == team).size()
