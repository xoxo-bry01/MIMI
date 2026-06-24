extends Area2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var collected_sound: AudioStreamPlayer2D =$CollectedSound

signal collected

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_body_entered(_body: Node2D) -> void:
	animated_sprite_2d.play("collected")
	collected.emit()
	print("apple collected")
	await get_tree().create_timer(0.3).timeout
	queue_free()
