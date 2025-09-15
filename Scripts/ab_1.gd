extends Node2D

# Dash ability
# Used to apply a force in the held direction, excluding upwards

var dash_impulse: float = 600
var cooldown: float = 3.0
var can_activate: bool = true

# When the cooldown timer runs out, this is called which allows the activation of abilities again
func _on_timer_timeout() -> void:
	can_activate = true

func activate(player, player_id):
	# Cuts the ability activation short to prevent ability use while on cooldown
	if not can_activate:
		return

	can_activate = false
	# creates and starts a timer with length (cooldown) that will stop the player using the ability until finished
	var t = get_tree().create_timer(cooldown)
	t.timeout.connect(_on_timer_timeout)

	var dir = Vector2.ZERO

	# Gets the inputs of the player that is using the ability
	var right = "player_%d_right" % player_id
	var left = "player_%d_left" % player_id
	var up = "player_%d_jump" % player_id
	var down = "player_%d_fall" % player_id

	if Input.is_action_pressed(right):
		dir.x = 1
	if Input.is_action_pressed(left):
		dir.x = -1
	if Input.is_action_pressed(up):
		dir.y = 0#-1
	if Input.is_action_pressed(down):
		dir.y = 0#1

	# If no input, dash in direction of player's horizontal velocity
	if dir == Vector2.ZERO or dir.x == 0:
		if player.linear_velocity.x > 0:
			dir.x = 1
		elif player.linear_velocity.x < 0:
			dir.x = -1
		else:
			dir.x = 1  # default to right

	# clamp to allowed dash angles
	var final_dir = map_to_dash_angle(dir, player)

	player.apply_central_impulse(dir * dash_impulse)

# Takes the input direction, normalizes it, and then maps it to 30 degrees above or below horizontal
func map_to_dash_angle(input_dir: Vector2, player: RigidBody2D) -> Vector2:
	input_dir = input_dir.normalized()

	var cos30 = 0.8660254
	var sin30 = 0.5

	# horizontal only
	if input_dir.y == 0:
		return Vector2(sign(input_dir.x), 0)

	# diagonal cases
	if input_dir.x > 0:
		if input_dir.y < 0:
			return Vector2(cos30, -sin30)   # up-right
		else:
			return Vector2(cos30, sin30)    # down-right
	elif input_dir.x < 0:
		if input_dir.y < 0:
			return Vector2(-cos30, -sin30)  # up-left
		else:
			return Vector2(-cos30, sin30)   # down-left

	# if input_dir.x == 0 (pure vertical), fall back to velocity / default
	if player.linear_velocity.x >= 0:
		return Vector2(cos30, sign(input_dir.y) * sin30)
	else:
		return Vector2(-cos30, sign(input_dir.y) * sin30)
