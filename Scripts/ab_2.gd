extends Node2D

# Jetpack ability
# Used to apply a force in the held direction, excluding horizontal

var jetpack_impulse: float = 600
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
		dir.x = 0#1
	if Input.is_action_pressed(left):
		dir.x = 0#-1
	if Input.is_action_pressed(up):
		dir.y = -1
	if Input.is_action_pressed(down):
		dir.y = 1

	# If no input, boost in direction of player's vertical velocity
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
