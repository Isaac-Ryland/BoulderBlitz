extends Node2D
## Jetpack ability
## 
## Used to apply a force in the held direction, excluding horizontal

const jetpack_impulse: float = 600
const cooldown: float = 3.0

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
	var controls = GameData.player_controls[player_id]

	if Input.is_action_pressed(controls.jump):
		dir.y = -1
	if Input.is_action_pressed(controls.fall):
		dir.y = 1

	# If no input, boost in direction of player's vertical velocity
	if dir == Vector2.ZERO or dir.y == 0:
		if player.linear_velocity.y > 0:
			dir.y = 1
		elif player.linear_velocity.y < 0:
			dir.y = -1
		else:
			dir.y = 1  # default to up

	# Apply force
	player.apply_central_impulse(dir * jetpack_impulse)
