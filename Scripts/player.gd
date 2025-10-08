extends RigidBody2D
## Player
##
## Handles the player's physics, movement, graphics, abilities, and collision

# References to Nodes in the node tree
@onready var ball_sprite: AnimatedSprite2D = $BallSprite
@onready var head_sprite: AnimatedSprite2D = $HeadSprite
@onready var one_way_ray: RayCast2D = $CollisionShape2D/OneWayRay
@onready var info_overlay: Control = $"../InfoOverlay"
@onready var rays = [
	$CollisionShape2D/LeftCast,
	$CollisionShape2D/TopLeftCast,
	$CollisionShape2D/TopCast,
	$CollisionShape2D/TopRightCast,
	$CollisionShape2D/RightCast,
	$CollisionShape2D/BottomRightCast,
	$CollisionShape2D/BottomCast,
	$CollisionShape2D/BottomLeftCast
	]

const move_force: float = 1000.0
const jump_impulse: float = 650.0
const quick_fall_speed: float = 1000.0
const wall_jump_impulse: float = 500
const boulder_radius_in_pixels: int = 100 # Used to scale the speed of the rolling animation
const moving_threshold: float = 0.01 # The minimum velocity the player needs to display the animation
const damage_threshold = 250 # The minimum amount of damage required to actually apply it
const jump_cooldown = 0.08
const one_way_collision_duration: int = 2 # The duration that collision is deactivated for one-way platforms

var is_grounded = false
var is_walled = false
var ground_normal = Vector2.UP
var wall_normal = Vector2.ZERO
var can_wall_jump = false
var is_falling = false
var jump_cooldown_timer = 0.0
var selected_abilities = [] # A list of all selected abilities of the player
var ability_selected_index = 0 # Used for cycling between the individual selected ability
var controls = {} # The control preset the player has chosen
var damage_scale = 6 # The amount damage is scaled down by before being applied. Used for balancing

@export var player_index = 0


# Once the player enters the scene, iterates through the player's abilities and instantiates them so they can be used
func _ready() -> void:
	GameData.player_health[player_index] = 1000 # Reset health to max
	controls = GameData.player_controls[player_index] # Assigns the player the controls they selected
	
	# Initialises the player's animation according to their chosen colour
	ball_sprite.play(GameData.player_colour[player_index])
	ball_sprite.speed_scale = 0
	head_sprite.play(GameData.player_colour[player_index])
	head_sprite.speed_scale = 0
	
	var abilities = [
		preload("res://Scenes/ab_1.tscn"),
		preload("res://Scenes/ab_2.tscn"),
		preload("res://Scenes/ab_3.tscn"),
		preload("res://Scenes/ab_4.tscn"),
		preload("res://Scenes/ab_5.tscn"),
		preload("res://Scenes/ab_6.tscn")
		]
	
	# Gets the selected abilities and adds the ability as a child of the player
	for ability in GameData.player_abilities[player_index]:
		if ability is String: # If the ability is empty, still add it to the list. This allows the player to not select an ability
			selected_abilities.append(ability)
		else:
			var scene = abilities[ability]
			if scene is PackedScene:
				var inst = scene.instantiate()
				add_child(inst)
				selected_abilities.append(inst)

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	is_grounded = false # Assume player is not grounded or walled unless told otherwise
	is_walled = false
	var contact_count = state.get_contact_count() # Get all the points of contact between the player and other surfaces

	# Iterates through each contact to see if it's a ground / wall. Updates is_grounded/walled accordingly
	for i in range(contact_count):
		# Other player detection
		var other = state.get_contact_collider_object(i) # Gets the type of object the player has collided with
		if other and other is RigidBody2D: # Bunch of checks to confirm that the object is another player
			var my_vel = GameData.player_last_velocity[self.player_index]
			var other_vel = GameData.player_last_velocity[other.player_index]
			_handle_player_collision(other, my_vel, other_vel)

		# Ground detection
		var normal = state.get_contact_local_normal(i)
		if normal.dot(Vector2.UP) > 0.6: # 1 = horizontal
			is_grounded = true
			ground_normal = normal
			break  # Quits loop once there is a contact with the "ground"

		# Wall detection
		if abs(normal.dot(Vector2.RIGHT)) > 0.6 and abs(normal.dot(Vector2.RIGHT)) != 0: # 0 = vertical
			is_walled = true
			wall_normal = normal
			break # Quits loop once there is a contact with a "wall"


func _physics_process(delta: float) -> void:
	var direction = 0
	GameData.player_last_velocity[player_index] = linear_velocity

	# cooldown to prevent multiple jumps in a single frame
	if jump_cooldown_timer > 0:
		jump_cooldown_timer -= delta

	# Left/right input
	if Input.is_action_pressed(controls.left):
		direction = -1
	if Input.is_action_pressed(controls.right):
		direction = 1

	# Cylces between which ability is currently selected
	if Input.is_action_just_pressed(controls.cycle):
		ability_selected_index += 1
		if ability_selected_index > 2:
			ability_selected_index = 0
		info_overlay.update_ability_icons(player_index, GameData.player_abilities[player_index], ability_selected_index) # Changes what ability in the overlay is highlighted

	# Activates the selected ability
	if Input.is_action_just_pressed(controls.use):
		if selected_abilities[ability_selected_index] is not String: # Makes sure the ability currently selected isn't blank
			if selected_abilities[ability_selected_index].has_method("activate"):
				selected_abilities[ability_selected_index].activate(self, player_index)

	# Resets the wall jump once the player has returned to the ground
	if is_grounded:
		can_wall_jump = true

	# Apply force for moving
	if direction != 0.0:
		apply_central_force(Vector2(direction * move_force, 0))

	# Jump
	if Input.is_action_pressed(controls.jump) and jump_cooldown_timer <= 0:
		if is_grounded:
			var jump_vec = ground_normal.normalized() * jump_impulse
			apply_central_impulse(jump_vec)

		# Wall jump
		if can_wall_jump and is_walled:
			var jump_vec = wall_normal.normalized() * wall_jump_impulse
			apply_central_impulse(jump_vec)

		jump_cooldown_timer = jump_cooldown

	# Quick fall
	if Input.is_action_pressed(controls.fall):
		if !is_grounded:
			apply_central_force(Vector2(0, quick_fall_speed))
		
		# Checks on a certain collision layer for one way platforms
		if one_way_ray.is_colliding():
			var collider = one_way_ray.get_collider()
			if collider is StaticBody2D: # Ensures the collsion detected is a platform
				add_collision_exception_with(collider) # Removes collision between the player and the platform
				await get_tree().create_timer(one_way_collision_duration).timeout # Removes the collsion for 3s before replacing it
				remove_collision_exception_with(collider) # Restores collsision between them

	# Animation systems:
	# Handles the direction of the head, by flipping the the sprite based on the velocity.
	if linear_velocity.x > 1:
		head_sprite.flip_h = false
	elif linear_velocity.x < -1:
		head_sprite.flip_h = true
	
	# Plays the boulder's rolling animation based off of the characters veloctiy for the animation speed
	# Also plays the head animation. Refers to the "player_x_colour" global var for the colour choice.
	if (round(100*(abs(linear_velocity.x)))/100) > moving_threshold:
		ball_sprite.play(GameData.player_colour[player_index])
		ball_sprite.speed_scale = linear_velocity.x/boulder_radius_in_pixels
		head_sprite.play(GameData.player_colour[player_index])
	else:
		ball_sprite.speed_scale = 0
		head_sprite.stop()


# Used to update the player's health after collision
func apply_dmg(damage: float):
	GameData.player_health[player_index] -= abs(damage)
	if GameData.player_health[player_index] <= 0:
		GameData.loser = player_index
		GameData.game_over = true
		queue_free() # "Kills" the player if their health is gone
	print(GameData.player_health[player_index], " Health left for player %s" % (player_index+1))


func _handle_player_collision(other: RigidBody2D, my_vel: Vector2, other_vel: Vector2):
	
	var rel_vel = other_vel - my_vel
	var normal = (other.global_position - global_position).normalized()
	var impact_speed = rel_vel.dot(normal)
	
	# If the speed is too small or the players are travelling away during contact, don't apply any damage
	if impact_speed >= 0 or abs(impact_speed) < damage_threshold:
		print("Damage too low or negative")
		return
	
	impact_speed = abs(impact_speed)
	
	var dmg = impact_speed / damage_scale
	
	# Only applies damage to the slower player
	if my_vel.length() < other_vel.length():
		print(impact_speed / damage_scale, " damage applied to ", self)
		apply_dmg(dmg)
