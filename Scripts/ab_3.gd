extends Node2D
## Frictionless ability
##
## Removes the friction of the player, meaning no deccelaration until the ability runs out
## Ability activates and stays on for a duration when ability button pressed

const cooldown: float = 18.0
const duration: float = 10.0
const default_friction: float = 0.25
const ability_friction: float = 0.0

var can_activate: bool = true # Flag for prevention of use when on cooldown


# When the cooldown timer runs out, allows the activation of the ability again
func _on_timer_timeout() -> void:
	can_activate = true


# After the ability runs out, restore the friction back to its original friction
func restore_original_friction(mat: PhysicsMaterial):
	mat.friction = default_friction


func activate(player, player_id):
	# Prevents ability use while on cooldown
	if not can_activate:
		return

	can_activate = false
	# Prevent re-use of the ability for (cooldown) amount of seconds
	var cooldown_timer = get_tree().create_timer(cooldown)
	cooldown_timer.timeout.connect(_on_timer_timeout)

	# Get the player's physics material
	var mat: PhysicsMaterial = player.physics_material_override

	# Remove friction
	mat.friction = ability_friction

	# Restore original friction after duration
	var duration_timer = get_tree().create_timer(duration)
	duration_timer.timeout.connect(func(): restore_original_friction(mat))
