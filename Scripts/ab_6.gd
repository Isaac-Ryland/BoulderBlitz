extends Node2D
## Spike ability
##
## Amplifies the damage applied to the other player on collision
## Ability activates and stays on for a duration when ability button pressed

const cooldown: float = 18.0
const duration: float = 10.0
const ability_damage_scale: float = 1.5

var can_activate: bool = true
var default_damage_scale: float = get_parent().damage_scale

# When the cooldown timer runs out, this is called which allows the activation of abilities again
func _on_timer_timeout() -> void:
	can_activate = true


func restore_original_damage_scale(player):
	player.damage_scale = default_damage_scale


func activate(player, player_index):
	# Prevents ability use while on cooldown
	if not can_activate:
		return

	can_activate = false
	# Prevent re-use of the ability for (cooldown) amount of seconds
	var cooldown_timer = get_tree().create_timer(cooldown)
	cooldown_timer.timeout.connect(_on_timer_timeout)

	# Set new damage scale
	player.damage_scale = ability_damage_scale

	# Restore original damage scale after duration
	var duration_timer = get_tree().create_timer(duration)
	duration_timer.timeout.connect(func(): restore_original_damage_scale(player))
