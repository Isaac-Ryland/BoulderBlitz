extends Node2D
## Grapple Ability
##
## Grapples onto the map and lets the player swing from the latch point
## Ability is toggled by the first press of the button, where after de-activation the cooldown applies

const cooldown: float = 10.0
const rope_colour: Color = Color(1, 1, 1, 1)
const local_ray_offset: int = 64
const min_grapple_dist: int = 16

var can_activate: bool = true
var is_grappled: bool = false
var current_rope_length: float
var hook_pos: Vector2


# When the cooldown timer runs out, this is called which allows the activation of abilities again
func _on_timer_timeout() -> void:
	can_activate = true


func activate(player, player_id):
	# Cuts the ability activation short to prevent ability use while on cooldown
	if not can_activate:
		return
	
	# Checks if grapple is already in use, if so, disconnects the grapple
	if is_grappled:
		is_grappled = false
		can_activate = false
		queue_redraw()
		# creates and starts a timer with length (cooldown) that will stop the player using the ability until finished
		var cooldown_timer = get_tree().create_timer(cooldown)
		cooldown_timer.timeout.connect(_on_timer_timeout)
		return

	# Gets the inputs of the player that is using the ability
	var controls = GameData.player_controls[player_id]
	var dir = Vector2.ZERO
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

	var ray_map = {
		Vector2(-1, 0):  get_parent().rays[0], # Left
		Vector2(-1, -1): get_parent().rays[1], # TopLeft
		Vector2(0, -1):  get_parent().rays[2], # Top
		Vector2(1, -1):  get_parent().rays[3], # TopRight
		Vector2(1, 0):   get_parent().rays[4], # Right
		Vector2(1, 1):   get_parent().rays[5], # BottomRight
		Vector2(0, 1):   get_parent().rays[6], # Bottom
		Vector2(-1, 1):  get_parent().rays[7], # BottomLeft
	}

	var ray = ray_map.get(dir, null) # Chooses the correct raycast

	if ray.is_colliding():  # HAPPENS ON KEY PRESS
		var collider = ray.get_collider()
		if collider is StaticBody2D and not is_grappled:
			hook_pos = ray.get_collision_point()
			current_rope_length	= global_position.distance_to(hook_pos)
			var rope = player.global_position - hook_pos
			if rope.length() < (local_ray_offset + min_grapple_dist): return
			is_grappled = true
			queue_redraw()


func _physics_process(delta: float) -> void:
	if not is_grappled:
		return
	
	queue_redraw()
	
	var player = get_parent()

	var rope = player.global_position - hook_pos
	var rope_normal = rope.normalized()
	var radial_speed = rope_normal.dot(player.linear_velocity)
	if radial_speed <= 0: 
		return
	else:
		player.linear_velocity -= radial_speed * rope_normal

	if rope.length() < current_rope_length:
		current_rope_length = rope.length()

	if rope.length() > current_rope_length:
		player.global_position = hook_pos + rope_normal * current_rope_length



func _draw() -> void:
	if not is_grappled:
		return
	
	draw_line(Vector2(0, -64), (hook_pos - get_parent().global_position), rope_colour, 10)
