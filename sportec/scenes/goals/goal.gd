class_name Goal
extends Node2D

@onready var back_area := %BackArea
@onready var targets := %Targets
@onready var scoring_area := %ScoringArea

var team := ""

func _ready() -> void:
	back_area.body_entered.connect(ballEnterBackArea.bind())
	scoring_area.body_entered.connect(ballEnterScoringArea.bind())

func init(manage_team: String) -> void:
	team = manage_team

func ballEnterBackArea(ball: Ball) -> void:
	ball.stop()

func randomTargetPos() -> Vector2:
	return targets.get_child(randi_range(0, targets.get_child_count() - 1)).global_position

func centerTargetPos() -> Vector2:
	return targets.get_child(int(targets.get_child_count() / 2.0)).global_position

func topTargetPos() -> Vector2:
	return targets.get_child(0).global_position

func bottomTargetPos() -> Vector2:
	return targets.get_child(targets.get_child_count() - 1).global_position

func getScoringArea() -> Area2D:
	return scoring_area

func ballEnterScoringArea(_ball: Ball) -> void:
	PlayerSound.playSound(PlayerSound.Sound.WHISTLE)
	GameEvents.teamScored.emit(team)
