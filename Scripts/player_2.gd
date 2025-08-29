extends RigidBody2D

@onready var ball_sprite: AnimatedSprite2D = $BallSprite
@onready var head_sprite: AnimatedSprite2D = $HeadSprite

@onready var left_cast: RayCast2D = $CollisionShape2D/LeftCast
@onready var right_cast: RayCast2D = $CollisionShape2D/RightCast

const move_force: float = 800.0
const jump_impulse: float = 650.0
const quick_fall_speed: float = 1000.0
const wall_jump_impulse: Vector2 = Vector2(500, jump_impulse)
const boulder_radius_in_pixels: int = 100
const moving_threshold: float = 0.01

var is_grounded = false
var ground_normal = Vector2.UP
var can_wall_jump = false
var is_falling = false
var jump_cooldown = 0.08
var jump_cooldown_timer = 0.0


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	is_grounded = false
	var contact_count = state.get_contact_count()

	for i in range(contact_count):
		var normal = state.get_contact_local_normal(i)
		if normal.dot(Vector2.UP) > 0.6: # 1 = horizontal
			is_grounded = true
			ground_normal = normal
			break  # quits loop once there is a contact with the "ground"

# WIP
func get_wall_normal(state: PhysicsDirectBodyState2D) -> Vector2:
	var contact_count = state.get_contact_count()

	for i in range(contact_count):
		var normal = state.get_contact_local_normal(i)
		if abs(normal.dot(Vector2.RIGHT)) < 0.6: # 0 = vertical
			return normal
	return Vector2.ZERO
# End WIP

func _physics_process(delta: float) -> void:
	var direction = 0

	# cooldown to prevent multiple jumps in a single frame
	if jump_cooldown_timer > 0:
		jump_cooldown_timer -= delta

	# Left/right input
	if Input.is_action_pressed("player_2_left"):
		direction = -1
	if Input.is_action_pressed("player_2_right"):
		direction = 1

	# Resets the wall jump once the player has returned to the ground
	if is_grounded:
		can_wall_jump = true

	# Apply force for moving
	if direction != 0.0:
		apply_central_force(Vector2(direction * move_force, 0))

	# Jump
	if Input.is_action_pressed("player_2_jump") and jump_cooldown_timer <= 0:
		if is_grounded:
			var jump_vec = ground_normal.normalized() * jump_impulse
			apply_central_impulse(jump_vec)

		# Wall jump
		if can_wall_jump and (left_cast.is_colliding() or right_cast.is_colliding()):
			can_wall_jump = false
			var wall_side = 1 if left_cast.is_colliding() else -1
			apply_central_impulse(Vector2(wall_side * wall_jump_impulse.x, -wall_jump_impulse.y))
		jump_cooldown_timer = jump_cooldown

	# Quick fall
	if Input.is_action_pressed("player_2_fall") and !is_grounded:
		apply_central_force(Vector2(0, quick_fall_speed))


	# Animation systems:
	# Handles the direction of the head, by flipping the the sprite based off of the velocity.
	if linear_velocity.x > 1:
		head_sprite.flip_h = false
	elif linear_velocity.x < -1:
		head_sprite.flip_h = true
	
	# Plays the boulder's rolling animation based off of the characters veloctiy for the animation speed
	# Also plays the head animation. Refers to the "player_2_colour" global var for the colour choice.
	if (round(100*(abs(linear_velocity.x)))/100) > moving_threshold:
		ball_sprite.play(GameData.player_2_colour)
		ball_sprite.speed_scale = linear_velocity.x/boulder_radius_in_pixels
		head_sprite.play(GameData.player_2_colour)
	else:
		ball_sprite.speed_scale = 0
		head_sprite.stop()
