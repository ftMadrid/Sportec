class_name Player
extends CharacterBody2D

const tackle_duration := 200

enum ControlScheme {CPU, P1}
enum State {MOVING, TACKLING}

@export var control_scheme : ControlScheme
@export var speed : float = 100.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite: Sprite2D = $PlayerSprite

var heading := Vector2.RIGHT
var state := State.MOVING
var start_tackle := Time.get_ticks_msec()

func _physics_process(_delta: float) -> void:
	
	if control_scheme == ControlScheme.CPU:
		pass # the movements for the AI (is bug now so dont try to collide with a cpu bro
	else:
		if state == State.MOVING:
			handle_human_moves()
			if velocity.x != 0 and Input.is_action_just_pressed("p_shoot"):
				state = State.TACKLING
				start_tackle = Time.get_ticks_msec()
			movement_animation()
		elif state == State.TACKLING:
			animation_player.play("tackle")
			if Time.get_ticks_msec() - start_tackle > tackle_duration:
				state = State.MOVING
		
	set_heading()
	move_and_slide()

func handle_human_moves() -> void:
	var dir := Input.get_vector("p_left", "p_right", "p_up", "p_down")
	velocity = dir * speed
	
func movement_animation() -> void:
	if velocity.length() > 0:
		animation_player.play("run")
	else:
		animation_player.play("idle")

func set_heading() -> void:
	if velocity.x > 0:
		heading = Vector2.RIGHT
		sprite.flip_h = false
	elif velocity.x < 0:
		heading = Vector2.LEFT
		sprite.flip_h = true
		
		
	
