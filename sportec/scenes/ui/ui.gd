class_name UI
extends CanvasLayer

@onready var team_img : Array[TextureRect] = [%HomeTeam, %AwayTeam]
@onready var score_text : Label = %Score
@onready var time_text : Label = %TimeLabel

func _ready() -> void:
	update_score()

func update_score() -> void:
	pass
