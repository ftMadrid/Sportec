class_name Goal
extends Node2D

@onready var back_area := %BackArea
@onready var targets := %Targets
@onready var scoring_area := %ScoringArea

var team := ""

func _ready() -> void:
	back_area.body_entered.connect(ball_enter_back_area.bind())
	scoring_area.body_entered.connect(ball_enter_scoring_area.bind())

func init(manage_team: String) -> void:
	team = manage_team

func ball_enter_back_area(ball: Ball) -> void:
	ball.stop()

func random_target_position() -> Vector2:
	return targets.get_child(randi_range(0, targets.get_child_count() - 1)).global_position

func center_target_position() -> Vector2:
	return targets.get_child(int(targets.get_child_count() / 2.0)).global_position

func top_target_pos() -> Vector2:
	return targets.get_child(0).global_position

func bottom_target_pos() -> Vector2:
	return targets.get_child(targets.get_child_count() - 1).global_position

func get_scoring_area() -> Area2D:
	return scoring_area

func ball_enter_scoring_area(_ball: Ball) -> void:
	PlayerSound.playSound(PlayerSound.Sound.WHISTLE)
	GameEvents.team_scored.emit(team)
