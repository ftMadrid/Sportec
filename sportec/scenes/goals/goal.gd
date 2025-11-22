class_name Goal
extends Node2D

@onready var back_area := %BackArea
@onready var targets := %Targets

func _ready() -> void:
	back_area.body_entered.connect(ball_enter_back_area.bind())

func ball_enter_back_area(ball: Ball) -> void:
	ball.stop()

func random_target_position() -> Vector2:
	return targets.get_child(randi_range(0, targets.get_child_count() - 1)).global_position
