extends Node2D

var jetpack_impulse: float = 600

func activate(player, player_id):
	var dir = Vector2.ZERO

	var right = "player_%d_right" % player_id
	var left = "player_%d_left" % player_id
	var up = "player_%d_jump" % player_id
	var down = "player_%d_fall" % player_id

	if Input.is_action_pressed(right):
		dir.x = 0#1
	if Input.is_action_pressed(left):
		dir.x = 0#-1
	if Input.is_action_pressed(up):
		dir.y = -1
	if Input.is_action_pressed(down):
		dir.y = 1

	# If no input, boost in direction of player's velocity
	if dir == Vector2.ZERO or dir.y == 0:
		if player.linear_velocity.y > 0:
			dir.y = -1
		elif player.linear_velocity.y < 0:
			dir.y = 1
		else:
			dir.y = -1  # default to up

	dir = dir.normalized()

	# Apply force
	player.apply_central_impulse(dir * jetpack_impulse)
