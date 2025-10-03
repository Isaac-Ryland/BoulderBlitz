extends Node2D
## Spike ability
##
## Amplifies the damage applied to the other player on collision
## Ability activates and stays on for a duration when ability button pressed

const cooldown: float = 18.0
const duration: float = 10.0
const default_damage_scale: float = 5
const ability_damage_scale: float = 1.5

var can_activate: bool = true


# When the cooldown timer runs out, this is called which allows the activation of abilities again
func _on_timer_timeout() -> void:
	can_activate = true


func _restore_original_scale(player):
	player.damage_scale = default_damage_scale


func activate(player, player_id):
	# Prevents ability use while on cooldown
	if not can_activate:
		return

	can_activate = false
	# creates and starts a timer with length (cooldown) that will stop the player using the ability until finished
	var cooldown_timer = get_tree().create_timer(cooldown)
	cooldown_timer.timeout.connect(_on_timer_timeout)

	# Get the damage scale from the player
	var damage_scale = player.damage_scale

	# Store the original damage scale to use later
	var original_damage_scale = damage_scale

	# Set new damage scale
	player.damage_scale = ability_damage_scale

	# Restore original friction after duration
	var duration_timer = get_tree().create_timer(duration)
	duration_timer.timeout.connect(func(): _restore_original_scale(player))
