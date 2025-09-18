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
	var cooldown_timer = get_tree().create_timer(cooldown)
	cooldown_timer.timeout.connect(_on_timer_timeout)

	var dir = Vector2.ZERO

	# Gets the inputs of the player that is using the ability
	var right = "player_%d_right" % player_id
	var left = "player_%d_left" % player_id
	
	if Input.is_action_pressed(right):
		dir.x = 1
	if Input.is_action_pressed(left):
		dir.x = -1

	# If no input, dash in direction of player's horizontal velocity
	if dir == Vector2.ZERO or dir.x == 0:
		if player.linear_velocity.x > 0:
			dir.x = 1
		elif player.linear_velocity.x < 0:
			dir.x = -1
		else:
			dir.x = 1  # default to right

	player.apply_central_impulse(dir * dash_impulse)
