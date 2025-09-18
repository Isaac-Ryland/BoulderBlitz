extends RigidBody2D

@onready var ball_sprite: AnimatedSprite2D = $BallSprite
@onready var head_sprite: AnimatedSprite2D = $HeadSprite
@onready var ray: RayCast2D = $CollisionShape2D/RayCast2D
@onready var info_overlay: Control = $"../InfoOverlay"

const move_force: float = 1000.0
const vel_cap: float = 1500.0
const jump_impulse: float = 650.0
const quick_fall_speed: float = 1000.0
const wall_jump_impulse: Vector2 = Vector2(500, 0)
const boulder_radius_in_pixels: int = 100
const moving_threshold: float = 0.01
const jump_cooldown = 0.08
const damage_threshold = 250
const damage_scale = 4

var is_grounded = false
var is_walled = false
var ground_normal = Vector2.UP
var wall_normal = Vector2.ZERO
var can_wall_jump = false
var is_falling = false
var jump_cooldown_timer = 0.0
var abilities = []
var ability_selected = 0

# Once the player enters the scene, iterates through the player's abilities and instantiates them so they can be used
func _ready() -> void:
	GameData.player_2_health = 1000
	
	ball_sprite.play(GameData.player_2_colour)
	ball_sprite.speed_scale = 0
	head_sprite.play(GameData.player_2_colour)
	head_sprite.speed_scale = 0
	
	for ab in GameData.player_2_abilities:
		var scene = GameData.abilities[ab]
		if scene is PackedScene:
			var inst = scene.instantiate()
			add_child(inst)
			abilities.append(inst)
		elif scene is String:
			abilities.append(scene)

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	is_grounded = false # Assume player is not grounded or walled unless told otherwise
	is_walled = false
	var contact_count = state.get_contact_count() # Get all the points of contact between the player and other surfaces

	for i in range(contact_count): # Iterates through each contact to see if it's a ground / wall. Updates is_grounded/walled accordingly
		var other = state.get_contact_collider_object(i) # Gets the type of object the player has collided with
		if other and other is RigidBody2D: # Check to confirm that the object is another player
			_handle_player_collision(other)
		
		var normal = state.get_contact_local_normal(i)
		if normal.dot(Vector2.UP) > 0.6: # 1 = horizontal
			is_grounded = true
			ground_normal = normal
			break  # Quits loop once there is a contact with the "ground"

		if abs(normal.dot(Vector2.RIGHT)) > 0.6 and abs(normal.dot(Vector2.RIGHT)) != 0: # 0 = vertical
			is_walled = true
			wall_normal = normal
			break # Quits loop once there is a contact with a "wall"

func _physics_process(delta: float) -> void:
	var direction = 0

	# cooldown to prevent multiple jumps in a single frame
	if jump_cooldown_timer > 0:
		jump_cooldown_timer -= delta

	# Left/right input
	if Input.is_action_pressed("player_2_left"):
		direction = -1
	if Input.is_action_pressed("player_2_right"):
		direction = 1

	# Cylces between which ability is currently selected
	if Input.is_action_just_pressed("player_2_ability_cycle"):
		ability_selected += 1
		if ability_selected > 2:
			ability_selected = 0
		info_overlay.update_ability_icons(2, GameData.player_2_abilities, ability_selected)

	# Activates the selected ability
	if Input.is_action_just_pressed("player_2_ability_use"):
		if abilities[ability_selected] is not String:
			if abilities[ability_selected].has_method("activate"):
				abilities[ability_selected].activate(self, 1)

	# Resets the wall jump once the player has returned to the ground
	if is_grounded:
		can_wall_jump = true

	# Apply force for moving
	if direction != 0.0:
		apply_central_force(Vector2(direction * move_force, 0))

	# Jump
	if Input.is_action_pressed("player_2_jump") and jump_cooldown_timer <= 0:
		if is_grounded:
			var jump_vec = ground_normal.normalized() * jump_impulse
			apply_central_impulse(jump_vec)

		# Wall jump
		if can_wall_jump and is_walled:
			var jump_vec = wall_normal.normalized() * wall_jump_impulse
			apply_central_impulse(jump_vec)

		jump_cooldown_timer = jump_cooldown

	# Quick fall
	if Input.is_action_pressed("player_2_fall"):
		if !is_grounded:
			apply_central_force(Vector2(0, quick_fall_speed))
		
		# Checks on a certain collision layer for platforms that the player can fall through
		if ray.is_colliding():
			var collider = ray.get_collider()
			if collider is StaticBody2D: # Ensures the collsion detected is a platform
				add_collision_exception_with(collider)
				await get_tree().create_timer(3).timeout # Removes the collsion for 3s before replacing it
				remove_collision_exception_with(collider)

	# Caps the player's horizontal velocity as to let me increase the acceleration of the player without breaking the balance
	if abs(linear_velocity.x) > vel_cap:
		linear_velocity.x = sign(linear_velocity.x) * vel_cap

	# Animation systems:
	# Handles the direction of the head, by flipping the the sprite based off of the velocity.
	if linear_velocity.x > 1:
		head_sprite.flip_h = false
	elif linear_velocity.x < -1:
		head_sprite.flip_h = true

	# Plays the boulder's rolling animation based off of the characters veloctiy for the animation speed
	# Also plays the head animation. Refers to the "player_2_colour" global var for the colour choice.
	if (round(100*(abs(linear_velocity.x)))/100) > moving_threshold:
		ball_sprite.play(GameData.player_2_colour)
		ball_sprite.speed_scale = linear_velocity.x/boulder_radius_in_pixels
		head_sprite.play(GameData.player_2_colour)
	else:
		ball_sprite.speed_scale = 0
		head_sprite.stop()

# Used to update the player's health after collision
func apply_dmg(damage):
	GameData.player_2_health -= abs(round(damage))
	if GameData.player_2_health <= 0:
		print("Player 2 has died! Player 1 wins!")
		queue_free() # "Kills" the player if there health is gone
	print(GameData.player_2_health, " Health left for player 2")

func _handle_player_collision(other: RigidBody2D):
	var rel_vel = linear_velocity - other.linear_velocity
	var normal = (other.global_position - global_position).normalized()
	var impact_speed = rel_vel.dot(normal)
	print(impact_speed)
	
	if abs(impact_speed) < damage_threshold:
		return
	
	var my_speed = abs(linear_velocity.length())
	var their_speed = abs(other.linear_velocity.length())

	if my_speed > their_speed:
		var dmg = impact_speed / damage_scale
		other.apply_dmg(dmg)
	elif my_speed < their_speed:
		var dmg = impact_speed / damage_scale
		apply_dmg(dmg)
