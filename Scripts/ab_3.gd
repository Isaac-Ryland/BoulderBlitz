extends Node2D

# Frictionless ability
# Removes the friction of the player, meaning no deccelaration until the ability runs out

const cooldown: float = 3.0
const duration: float = 6.0
const default_friction: float = 0.25

var can_activate: bool = true

# When the cooldown timer runs out, this is called which allows the activation of abilities again
func _on_timer_timeout() -> void:
	can_activate = true

func _restore_original_friction(mat: PhysicsMaterial, stored_friction: float):
	if stored_friction != default_friction:
		mat.friction = default_friction

func activate(player, player_id):
	# Prevents ability use while on cooldown
	if not can_activate:
		return

	can_activate = false
	# creates and starts a timer with length (cooldown) that will stop the player using the ability until finished
	var cooldown_timer = get_tree().create_timer(cooldown)
	cooldown_timer.timeout.connect(_on_timer_timeout)

	# Get the player's physics material
	var mat: PhysicsMaterial = player.physics_material_override

	# Storing origonal friction
	var original_friction = mat.friction

	# Remove friction
	mat.friction = 0.0

	# Restore original friction after duration
	var duration_timer = get_tree().create_timer(duration)
	duration_timer.timeout.connect(func(): _restore_original_friction(mat, original_friction))
