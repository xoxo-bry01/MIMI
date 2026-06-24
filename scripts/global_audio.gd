extends Node

# GLOBAL MUSIC MANAGER

var menu_music_player: AudioStreamPlayer2D
var welcome_chime_player: AudioStreamPlayer2D
var win_music_player: AudioStreamPlayer2D # 🌸 New player for the victory screen

# Put the paths to your audio files here!
var title_music_path = "res://assets/sounds/welcomesound.mp3" 
var win_sound_path = "res://assets/sounds/winner-sound.mp3" # 🎵 Change this to your exact win sound path if it lives somewhere else!

func _ready() -> void:
	# 1. Setup the main looping menu music
	menu_music_player = AudioStreamPlayer2D.new()
	add_child(menu_music_player)
	menu_music_player.stream = load(title_music_path)
	
	# 2. Setup the one-shot welcome sound
	welcome_chime_player = AudioStreamPlayer2D.new()
	add_child(welcome_chime_player)
	
	# 3. Setup the victory sound player
	win_music_player = AudioStreamPlayer2D.new()
	add_child(win_music_player)
	win_music_player.stream = load(win_sound_path)
	win_music_player.volume_db = -5.0 # Lower this number (like -10.0) if it's too loud!

func play_menu_music() -> void:
	if menu_music_player and not menu_music_player.playing:
		menu_music_player.play()

func stop_menu_music() -> void:
	if menu_music_player and menu_music_player.playing:
		menu_music_player.stop()

func play_welcome_voice(sound_stream: AudioStream) -> void:
	if welcome_chime_player and sound_stream:
		welcome_chime_player.stream = sound_stream
		welcome_chime_player.play()

# 🌸 New function to trigger when you beat Level 3!
func play_win_sound() -> void:
	# Stop the menu music if it happens to be running
	stop_menu_music()
	
	# Play the victory cheer
	if win_music_player and not win_music_player.playing:
		win_music_player.play()
