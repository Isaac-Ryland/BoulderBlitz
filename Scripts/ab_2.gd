extends Node2D
## Jetpack ability
## 
## Used to apply a force in the held direction, excluding horizontal
## Ability fires once on ability button pressed

const jetpack_impulse: float = 600
const cooldown: float = 3.0

var can_activate: bool = true # Flag for prevention of use when on cooldown


# When the cooldown timer runs out, allows the activation of the ability again
func _on_timer_timeout() -> void:
	can_activate = true


func activate(player, player_index):
	# Prevents ability use while on cooldown
	if not can_activate:
		return

	can_activate = false
	# Prevent re-use of the ability for (cooldown) amount of seconds
	var cooldown_timer = get_tree().create_timer(cooldown)
	cooldown_timer.timeout.connect(_on_timer_timeout)

	var dir = Vector2.ZERO # A vector representing the direction of the player. Primarily set by inputs, but if no input may fall back to player velocity
	var controls = GameData.player_controls[player_index] # Gets the keybinds of the player

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
