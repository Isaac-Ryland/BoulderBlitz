extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -450.0
const DRAG = 0.05

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("player_2_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("player_2_left", "player_2_right")
	
	# Sprite flipping
	if velocity.x < 0:
		animated_sprite.flip_h = true
	elif velocity.x > 0:
		animated_sprite.flip_h = false
	
	# Sprite Animations 
	if velocity.x > 600 or velocity.x < -600:
		animated_sprite.play("RollFast")
	elif velocity.x > 10 or velocity.x < -10:
		animated_sprite.play("RollSlow")
	else:
		animated_sprite.stop()
	
	# Movement and deceleration
	if direction != 0:
		velocity.x += (direction * (SPEED/25))
	elif is_on_floor(): # Add drag
		velocity = velocity - DRAG * velocity

	move_and_slide()
