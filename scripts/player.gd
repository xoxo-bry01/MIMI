extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var jump_sound = $JumpSound
@onready var death_sound = $DeathSound

const SPEED = 300.0
const GRAVITY = 1800.0
const JUMP_VELOCITY = -850.0

var alive = true
var can_move = true

func _physics_process(delta):

	if !alive:
		return

	if not is_on_floor():
		velocity.y += GRAVITY * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = 0

	if can_move:
		direction = Input.get_axis("move_left", "move_right")

		if direction:
			velocity.x = direction * SPEED
			anim.flip_h = direction < 0
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

	update_animations(direction)

func update_animations(direction):

	if not is_on_floor():
		anim.play("jump")
	elif direction != 0:
		anim.play("walk")
	else:
		anim.play("idle")

func die() -> void:
	death_sound.play()
	anim.play("dying")
	can_move = false
	alive = false

func disappear() -> void:
	can_move = false
	anim.play("disappear")
	await anim.animation_finished
