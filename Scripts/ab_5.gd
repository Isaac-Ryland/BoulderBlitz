extends Node2D
## Slingshot Ability
##
## Latches onto the map and accelerates the player towards the latch point
## Ability stays on for as long as ability button is held or until the slingshot reaches a certain length
## Ability then goes on cooldown after button release / disconnect

const cooldown: float = 3.0
const rope_colour: Color = Color(1, 1, 1, 1)
const local_ray_offset: int = 64
const min_hook_dist: int = 16
const yoink_impulse: float = 30

var can_activate: bool = true
var is_hooked: bool = false
var current_rope_length: float
var hook_pos: Vector2
	#Vector2(-1, 0):  get_parent().rays[0],
	#Vector2(-1, -1): get_parent().rays[1],
	#Vector2(0, -1):  get_parent().rays[2],
	#Vector2(1, -1):  get_parent().rays[3],
	#Vector2(1, 0):   get_parent().rays[4],
	#Vector2(1, 1):   get_parent().rays[5],
	#Vector2(0, 1):   get_parent().rays[6],
	#Vector2(-1, 1):  get_parent().rays[7],
#}


# When the cooldown timer runs out, this is called which allows the activation of abilities again
func _on_timer_timeout() -> void:
	can_activate = true


func activate(player, player_index):
	# Cuts the ability activation short to prevent ability use while on cooldown
	if not can_activate:
		return
	
	# Checks if slingshot is already in use, if so, disconnects the slingshot
	if is_hooked:
		is_hooked = false
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
		if player.linear_velocity.x > 0:
			dir.x = 1
		elif player.linear_velocity.x < 0:
			dir.x = -1
		elif player.linear_velocity.y > 0:
			dir.y = -1
		elif player.linear_velocity.y < 0:
			dir.y = 1
		else:
			dir = Vector2(1, -1)  # default to top right
	elif dir.x == 0:
		if player.linear_velocity.x > 0:
			dir.x = 1
		elif player.linear_velocity.x < 0:
			dir.x = -1
		else:
			dir.x = 1
	elif dir.y == 0:
		if player.linear_velocity.y > 0:
			dir.y = -1
		elif player.linear_velocity.y < 0:
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
		var collider = ray.get_collider()
		if collider is StaticBody2D and not is_hooked:
			hook_pos = ray.get_collision_point()
			current_rope_length	= global_position.distance_to(hook_pos)
			if current_rope_length < min_hook_dist: return # If the hook pos is too close to the player then slingshot will not activate
			is_hooked = true
			queue_redraw()


func _physics_process(delta: float) -> void:
	# Only runs if the slingshot is currently active
	if not is_hooked:
		return
	
	queue_redraw()
	
	var player = get_parent()

	# Accelerates the player towards the the hook point
	var rope = player.global_position - hook_pos
	var rope_normal = rope.normalized()
	player.apply_central_impulse(yoink_impulse * -rope_normal)


# Draws a line from the centre of the player to the hook point to visualise the slingshot
func _draw() -> void:
	# Only draws the line when the slingshot is attached
	if not is_hooked:
		return
	
	draw_line(Vector2(0, -64), (hook_pos - get_parent().global_position), rope_colour, 10)
