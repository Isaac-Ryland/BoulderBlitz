extends Node2D

var dash_impulse: float = 600

func activate(player, player_id):
	var dir = Vector2.ZERO

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

	# If no input, dash in direction of player's velocity
	if dir == Vector2.ZERO or dir.x == 0:
		if player.linear_velocity.x > 0:
			dir.x = 1
		elif player.linear_velocity.x < 0:
			dir.x = -1
		else:
			dir.x = 1  # default to right

	# clamp to allowed dash angles
	var final_dir = _map_to_dash_angle(dir, player)

	player.apply_central_impulse(dir * dash_impulse)


func _map_to_dash_angle(input_dir: Vector2, player: RigidBody2D) -> Vector2:
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
