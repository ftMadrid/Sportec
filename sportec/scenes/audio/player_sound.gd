extends Node

enum Sound {HURT, PASS, POWERSHOOT, SHOOT, BOUNCE, TACKLE, NAVIGATION, SELECT, WHISTLE}

const channels := 4

const AUDIO_MAP: Dictionary[Sound, AudioStream] = {
	
	Sound.HURT: preload("res://assets/sfx/hurt.wav"),
	Sound.PASS: preload("res://assets/sfx/pass.wav"),
	Sound.POWERSHOOT: preload("res://assets/sfx/power-shot.wav"),
	Sound.SHOOT: preload("res://assets/sfx/shoot.wav"),
	Sound.BOUNCE: preload("res://assets/sfx/bounce.wav"),
	Sound.TACKLE: preload("res://assets/sfx/tackle.wav"),
	Sound.NAVIGATION: preload("res://assets/sfx/ui-navigate.wav"),
	Sound.SELECT: preload("res://assets/sfx/ui-select.wav"),
	Sound.WHISTLE: preload("res://assets/sfx/whistle.wav"),
	
}

var stream_players : Array[AudioStreamPlayer] = []

func _ready() -> void:
	for i in range(channels):
		var stream_player := AudioStreamPlayer.new()
		stream_player.bus = "Sfx"
		stream_players.append(stream_player)
		add_child(stream_player)

func findAvailablePlayer() -> AudioStreamPlayer:
	for stream_player in stream_players:
		if not stream_player.playing:
			return stream_player
	return null

func playSound(sound: Sound) -> void:
	var stream_player := findAvailablePlayer()
	if stream_player != null:
		stream_player.stream = AUDIO_MAP[sound]
		stream_player.play()
		stream_player.volume_db = 2
