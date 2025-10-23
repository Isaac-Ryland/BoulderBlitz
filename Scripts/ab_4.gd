extends Node2D
class_name Ab4
## Grapple Ability
##
## Grapples onto the map and lets the player swing from the latch point
## Ability is toggled by the first press of the button, where after de-activation the cooldown applies

const cooldown: float = 5.0
const rope_colour: Color = Color(0.25, 0.25, 0.25, 1)
const min_grapple_dist: int = 100 # Takes the player's radius plus a margin and used to prevent grapples from too close
const moving_threshold: float = 10 # The minimum velocity for velocity based directions

var can_activate: bool = true # Flag for prevention of use when on cooldown
var is_grappled: bool = false # Flag for toggling grapple on and off
var current_rope_length: float
var collider
var hook_pos: Vector2
var hook_local_pos: Vector2
var current_hook_pos: Vector2


# When the cooldown timer runs out, allows the activation of the ability again
func _on_timer_timeout() -> void:
	can_activate = true


func activate(player, player_index):
	# Prevents ability use while on cooldown
	if not can_activate:
		return
	
	# Checks if grapple is already in use, if so, disconnects the grapple
	if is_grappled:
		is_grappled = false
		can_activate = false
		queue_redraw()
		# Prevent re-use of the ability for (cooldown) amount of seconds
		var cooldown_timer = get_tree().create_timer(cooldown)
		cooldown_timer.timeout.connect(_on_timer_timeout)
		return

	var dir = Vector2.ZERO # A vector representing the direction of the player. Primarily set by inputs, but if no input may fall back to player velocity
	var controls = GameData.player_controls[player_index] # Gets the keybinds of the player
	if Input.is_action_pressed(controls.right):
		dir.x = 1
	if Input.is_action_pressed(controls.left):
		dir.x = -1
	if Input.is_action_pressed(controls.jump):
		dir.y = -1
	if Input.is_action_pressed(controls.fall):
		dir.y = 1

	# If no input, hook in direction of player's velocity
	if dir == Vector2.ZERO:
		if player.linear_velocity.x > moving_threshold:
			dir.x = 1
		elif player.linear_velocity.x < -moving_threshold:
			dir.x = -1
		elif player.linear_velocity.y > moving_threshold:
			dir.y = -1
		elif player.linear_velocity.y < -moving_threshold:
			dir.y = 1
		else:
			dir = Vector2(1, -1)  # default to top right
	elif dir.x == moving_threshold:
		if player.linear_velocity.x > moving_threshold:
			dir.x = 1
		elif player.linear_velocity.x < -moving_threshold:
			dir.x = -1
		else:
			dir.x = 1
	elif dir.y == moving_threshold:
		if player.linear_velocity.y > moving_threshold:
			dir.y = -1
		elif player.linear_velocity.y < -moving_threshold:
			dir.y = 1
		else:
			dir.y = -1

	var rays = {
		Vector2(-1, 0):  get_parent().rays[0], # Left
		Vector2(-1, -1): get_parent().rays[1], # TopLeft
		Vector2(0, -1):  get_parent().rays[2], # Top
		Vector2(1, -1):  get_parent().rays[3], # TopRight
		Vector2(1, 0):   get_parent().rays[4], # Right
		Vector2(1, 1):   get_parent().rays[5], # BottomRight
		Vector2(0, 1):   get_parent().rays[6], # Bottom
		Vector2(-1, 1):  get_parent().rays[7], # BottomLeft
		}

	var ray = rays.get(dir, null) # Chooses the raycast that corresponds to the correct direction

	# If the raycast is colliding, set the hook position and rope length
	if ray.is_colliding():
		collider = ray.get_collider()
		if not is_grappled:
			hook_pos = ray.get_collision_point()
			hook_local_pos = collider.to_local(hook_pos)
			current_rope_length = global_position.distance_to(hook_pos)
			if current_rope_length < min_grapple_dist: return # If the hook pos is too close to the player then the grapple will not activate
			is_grappled = true
			queue_redraw()


func _physics_process(delta: float) -> void:
	# Only runs if the grapple is currently active
	if not is_grappled:
		return

	queue_redraw()

	var player = get_parent()

	current_hook_pos = collider.to_global(hook_local_pos)
	var rope = player.global_position - current_hook_pos
	var rope_normal = rope.normalized()
	
	# Clamps players velocity to give circular motion around the hook point
	var radial_speed = rope_normal.dot(player.linear_velocity)
	if radial_speed <= 0: 
		return
	else:
		player.linear_velocity -= radial_speed * rope_normal

	if rope.length() < min_grapple_dist:
		is_grappled = false
		can_activate = false
		queue_redraw()
		# Prevent re-use of the ability for (cooldown) amount of seconds
		var cooldown_timer = get_tree().create_timer(cooldown)
		cooldown_timer.timeout.connect(_on_timer_timeout)

	# Allow the rope to shrink in length if the player moves closer to the hook point
	if rope.length() < current_rope_length:
		current_rope_length = rope.length()

	# Prevets the rope from being extended
	if rope.length() > current_rope_length:
		player.global_position = current_hook_pos + rope_normal * current_rope_length


# Draws a line from the centre of the player to the hook point to visualise the grapple hook
func _draw() -> void:
	# Only draws the line when the grapple is attached
	if not is_grappled:
		return
	
	draw_line(Vector2(0, -64), (current_hook_pos - get_parent().global_position), rope_colour, 10)
