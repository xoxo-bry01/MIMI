extends Node2D
@onready var score_label: Label = $HUD/ScorePanel/ScoreLabel
@onready var level_label: Label = $HUD/LevelLabel
@onready var apple_label: Label = $HUD/AppleLabel
@onready var fade: ColorRect= $HUD/fade

var level: int = 1
var score: int = 0
var apples_collected: int = 0
var total_apples: int = 0
var current_level_root: Node = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	#setup the level
	fade.modulate.a = 1.0

	await _load_level(level, true, false)


#=======================
#LEVEL MANAGEMENT
#=======================
func _load_level(level_number: int, first_load: bool, reset_score: bool) -> void:
	#  FIX LIVES HERE: Check if they won BEFORE loading anything else!
	if level_number > 3:
		GlobalAudio.play_win_sound() # 🎵 Play the victory music!
		get_tree().change_scene_to_file("res://Scene/you_win.tscn")
		return
	# fade out
	if not first_load:
		await fade_screen(1.0)
	
	if reset_score:
		score= 0
		score_label.text= "SCORE:0 "
		
	if current_level_root:
		current_level_root.queue_free()
		await get_tree().process_frame
		
	#change level
	var level_path = "res://Scene/levels/level%s.tscn" % level_number
	current_level_root=  load(level_path).instantiate()
	add_child(current_level_root)
	current_level_root.name = "LevelRoot"
	_setup_level(current_level_root)

	level_label.text = "LEVEL: %s" % level

	#Fade in
	await fade_screen(0.0)


func _setup_level(level_root: Node) -> void:
	visible = true
	#connect Exit
	var exit = level_root.get_node_or_null("Exit")
	if exit:
		exit.body_entered.connect(_on_exit_body_entered)
	#connect apples
	var apples = level_root.get_node_or_null("Apple")
	if apples:
		total_apples = apples.get_child_count()
		apples_collected = 0
		update_apple_label()
		for apple in apples.get_children():
			apple.collected.connect(increase_score)
			print("connected apple")
	
	#connect enemies
	var enemies = level_root.get_node_or_null("Enemies")
	if enemies:
		for enemy in enemies.get_children():
			enemy.player_died.connect(_on_player_died)


#=======================
#SIGNAL HANDLERS
#=======================

func _on_exit_body_entered(body: Node2D) -> void:
	print(body.name)

	if body.name == "player":
		# 1. Stop Mimi from moving so the player loses control
		if "can_move" in body:
			body.can_move = false
		
		# 2. Make Mimi completely invisible (disappear!)
		body.visible = false
		
		# 3. Wait just half a second while she is invisible for dramatic effect
		await get_tree().create_timer(0.5).timeout

		# 4. Advance the level counter and load the next stage
		level += 1
		await _load_level(level, false, false)


func _on_player_died(body) -> void:
	print(body.name)

	if body.has_method("die"):
		body.die()

	# ========================================================
	# NEW: CAMERA ZOOM TWEEN EFFECT
	# ========================================================
	# Find the camera being used in your level scene
	var camera = get_viewport().get_camera_2d()
	if camera:
		var tween = create_tween().set_parallel(true)
		# Magnifies the camera frame closely onto Mimi's coordinate vector
		# (e.g., zooming from a standard 1.0 up to a tight 2.5)
		tween.tween_property(camera, "zoom", Vector2(2.5, 2.5), 0.8).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	# Wait for the dramatic camera zoom effect to finish tracking
	await get_tree().create_timer(1.2).timeout

	# Load your new beautiful Game Over layout scene asset
	var game_over_scene = load("res://Scene/game_over.tscn")
	var game_over_instance = game_over_scene.instantiate()
	$HUD.add_child(game_over_instance)

#=======================
#SCORE
#=======================

func increase_score() -> void:

	score += 1

	apples_collected += 1

	score_label.text = "SCORE: %s" % score

	update_apple_label()
	
	# ========================================================
	# NEW: AUDIO TRIGGER FOR COIN PICKUP
	# ========================================================
	if has_node("CoinSoundPlayer"):
		$CoinSoundPlayer.play() # Triggers your "cling cling" sound effect asset!

#=======================
#FADE
#=======================
func fade_screen(to_alpha: float) -> void:
	var tween:= create_tween()
	tween.tween_property(fade,"modulate:a", to_alpha, 1.5 )
	await tween.finished


func update_apple_label() -> void:

	apple_label.text = "APPLES: %s/%s" % [apples_collected, total_apples]
	
	
