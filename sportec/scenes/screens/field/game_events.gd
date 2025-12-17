extends Node

signal teamScored(teamScored: String)
signal teamReset
signal kickoff_ready
signal kickoff_started
signal ball_possessed(player_name: String)
signal ball_released
signal score_change
signal gameover(team_winner: String)
signal impact_received(impact_pos: Vector2, high_impact: bool)
