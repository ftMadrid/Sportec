class_name Goal
extends Node2D

@onready var back_area := %BackArea

func _ready() -> void:
	back_area.body_entered.connect(ball_enter_back_area.bind())

func ball_enter_back_area(ball: Ball) -> void:
	ball.stop()
