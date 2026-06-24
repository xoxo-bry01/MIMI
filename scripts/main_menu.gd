extends Control




func _on_quit_button_pressed() -> void:

	get_tree().quit()


func _on_play_button_pressed() -> void:
	GlobalAudio.stop_menu_music()
	get_tree().change_scene_to_file("res://Scene/main.tscn")
