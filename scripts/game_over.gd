extends Control

# GAME OVER SYSTEM MANAGEMENT CONTROL LAYER

func _ready() -> void:
	# Note: Your voice track triggers automatically if the "Autoplay" box is checked in the Inspector.
	# If you prefer to play it explicitly via script code instead, uncomment the next line:
	# $VoiceOverPlayer.play()
	pass

# Connected to the pressed() signal of your RetryButton node layout element
func _on_retry_button_pressed() -> void:
	var main_node = get_tree().root.get_node_or_null("Main")
	if main_node:
		# Reset camera zoom immediately so it doesn't look weird
		var camera = get_viewport().get_camera_2d()
		if camera:
			camera.zoom = Vector2(1.0, 1.0)
			
		# Reset our stage tracking parameters back to zero
		main_node.score = 0
		main_node.apples_collected = 0
		
		# Bypass the slow await chains by calling it instantly!
		main_node._load_level(main_node.level, true, true) 
		
		# Free the game over overlay scene memory immediately
		queue_free()
	else:
		get_tree().reload_current_scene()

# Connected to the pressed() signal of your MainMenuButton node layout element
func _on_main_menu_button_pressed() -> void:
	# This single line dumps the active game and opens your menu file!
	get_tree().change_scene_to_file("res://Scene/main_menu.tscn")
