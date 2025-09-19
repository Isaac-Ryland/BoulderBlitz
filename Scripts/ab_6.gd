extends Node2D
## Spike ability
##
## amplifies the damage applied to the other player on collision

const cooldown: float = 18.0
const duration: float = 10.0
const default_friction: float = 0.25

var can_activate: bool = true


# When the cooldown timer runs out, this is called which allows the activation of abilities again
func _on_timer_timeout() -> void:
	can_activate = true


func activate(player, player_id):
	# Prevents ability use while on cooldown
	if not can_activate:
		return

	can_activate = false
	# creates and starts a timer with length (cooldown) that will stop the player using the ability until finished
	var cooldown_timer = get_tree().create_timer(cooldown)
	cooldown_timer.timeout.connect(_on_timer_timeout)
