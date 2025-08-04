extends CharacterBody2D

@onready var ball_sprite: AnimatedSprite2D = $BallSprite
@onready var head_sprite: AnimatedSprite2D = $HeadSprite

const SPEED = 800.0
const JUMP_VELOCITY = -1000.0
const DRAG = 2
const BOULDER_RADIUS_IN_PIXELS = 100
const MOVING_THRESHOLD = 0.01

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("player_1_jump") and is_on_floor(): # or Input.is_action_just_pressed("player_1_jump") and is_on_wall():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("player_1_left", "player_1_right")

	# Handles the direction of the head, by flipping the the sprite based off of the velocity.
	if velocity.x > 0:
		head_sprite.flip_h = false
	elif velocity.x < 0:
		head_sprite.flip_h = true
	
	# Plays the boulder's rolling animation based off of the characters veloctiy for the animation speed
	# Also plays the head animation. Refers to the "player_1_colour" global var for the colour choice.
	if (round(100*(abs(velocity.x)))/100) > MOVING_THRESHOLD:
		ball_sprite.play(GameData.player_1_colour)
		ball_sprite.speed_scale = velocity.x/BOULDER_RADIUS_IN_PIXELS
		head_sprite.play(GameData.player_1_colour)
	else:
		ball_sprite.speed_scale = 0
		head_sprite.stop()
		
	# Handles the Movement and deceleration
	if direction != 0:
		velocity.x += direction * SPEED * delta
		if abs(velocity.x) > SPEED:
			velocity.x = direction * SPEED
	elif is_on_floor(): # Add drag
		velocity = velocity - DRAG * velocity * delta

	move_and_slide()
