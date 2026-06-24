extends Control

@onready var prompt_label: Label = %PromptLabel
@export var welcome_voice_file: AudioStream # Drop your "Welcome/Hi" voice file here in the inspector!

var blink_time: float = 0.0
var already_clicked: bool = false

func _ready() -> void:
	# Instantly start playing the menu music smoothly through the global system
	GlobalAudio.play_menu_music()

func _process(delta: float) -> void:
	blink_time += delta * 4.0
	if prompt_label:
		prompt_label.modulate.a = (sin(blink_time) + 1.0) / 2.0

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if not already_clicked:
			already_clicked = true
			handle_start_transition()

func handle_start_transition() -> void:
	# Play your voiceover overlay track on top of the looping music!
	if welcome_voice_file:
		GlobalAudio.play_welcome_voice(welcome_voice_file)
		await get_tree().create_timer(1.2).timeout # Let them hear the voice greeting cleanly
	else:
		await get_tree().create_timer(0.2).timeout
		
	get_tree().change_scene_to_file("res://Scene/main_menu.tscn")
