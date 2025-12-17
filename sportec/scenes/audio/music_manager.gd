extends Node2D

const TRACKS = {
	"menu": preload("res://assets/music/menu.mp3"),
	"gameplay": preload("res://assets/music/testing.mp3"),
	"winner": preload("res://assets/music/winner.mp3"),
}

@onready var player: AudioStreamPlayer = $MusicPlayer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func playMusic(track_name: String):
	if not TRACKS.has(track_name):
		print("This track doesnt exists - ", track_name)
		return

	var next_stream = TRACKS[track_name]

	if player.stream == next_stream and player.playing:
		return 

	player.stream = next_stream
	player.play()

func stopMusic():
	player.stop()
