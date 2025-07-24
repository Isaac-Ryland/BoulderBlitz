extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $BallSprite

const SPEED = 800.0
const JUMP_VELOCITY = -1000.0
const DRAG = 2
const BOULDER_RADIUS_IN_PIXELS = 64
const MOVING_THRESHOLD = 0.01

# Need to get the value of the player_1 colour var, and asign it to a var so it
# can be passed into the animated_sprite.play() func

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("player_1_jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("player_1_left", "player_1_right")
	
	# Sprite flipping
	#if velocity.x < MOVING_THRESHOLD:
	#	animated_sprite.flip_h = true
	#elif velocity.x > MOVING_THRESHOLD:
	#	animated_sprite.flip_h = false
	
	# Sprite Animations 
	#if abs(velocity.x) > (SPEED/2):
	#	animated_sprite.play("Anim1")
	#	animated_sprite.speed_scale = abs(velocity.x/SPEED)
	#elif abs(velocity.x) > 10:
	#	animated_sprite.play("Anim1")
	#	animated_sprite.speed_scale = abs(velocity.x/SPEED)
	
	if abs(velocity.x) > MOVING_THRESHOLD:
		animated_sprite.play(Main.player_1_colour)
		animated_sprite.speed_scale = velocity.x/BOULDER_RADIUS_IN_PIXELS
	else:
		animated_sprite.stop()
		
	# Movement and deceleration
	if direction != 0:
		velocity.x += direction * SPEED * delta
		if abs(velocity.x) > SPEED:
			velocity.x = direction * SPEED
	elif is_on_floor(): # Add drag
		velocity = velocity - DRAG * velocity * delta

	move_and_slide()
