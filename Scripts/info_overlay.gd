extends Control
## UI overlay 
##
## The overlay that displays info about both players during games

# References to Nodes in the scene tree
@onready var player_1_icon: TextureRect = $Control/P1
@onready var player_2_icon: TextureRect = $Control2/P2
@onready var p1_health_bar: TextureRect = $Control/HealthBar
@onready var p2_health_bar: TextureRect = $Control2/HealthBar
@onready var p1_ability_icons = [
	$Control/P1Abilities/Ab1,
	$Control/P1Abilities/Ab2,
	$Control/P1Abilities/Ab3
	]
@onready var p2_ability_icons = [
	$Control2/P2Abilities/Ab1,
	$Control2/P2Abilities/Ab2,
	$Control2/P2Abilities/Ab3
	]

# Textures for the left and right side minature player in the overlay
var p1_colour_textures = {
	"BLUE": preload("res://Assets/StartMenuArt/SelectMenuBoulderLeft/BlueBoulderLeft.png"),
	"GREEN": preload("res://Assets/StartMenuArt/SelectMenuBoulderLeft/GreenBoulderLeft.png"),
	"ORANGE": preload("res://Assets/StartMenuArt/SelectMenuBoulderLeft/OrangeBoulderLeft.png"),
	"PURPLE": preload("res://Assets/StartMenuArt/SelectMenuBoulderLeft/PurpleBoulderLeft.png"),
	"RED": preload("res://Assets/StartMenuArt/SelectMenuBoulderLeft/RedBoulderLeft.png"),
	"YELLOW": preload("res://Assets/StartMenuArt/SelectMenuBoulderLeft/YellowBoulderLeft.png")
	}
var p2_colour_textures = {
	"BLUE": preload("res://Assets/StartMenuArt/SelectMenuBoulderRight/BlueBoulderRight.png"),
	"GREEN": preload("res://Assets/StartMenuArt/SelectMenuBoulderRight/GreenBoulderRight.png"),
	"ORANGE": preload("res://Assets/StartMenuArt/SelectMenuBoulderRight/OrangeBoulderRight.png"),
	"PURPLE": preload("res://Assets/StartMenuArt/SelectMenuBoulderRight/PurpleBoulderRight.png"),
	"RED": preload("res://Assets/StartMenuArt/SelectMenuBoulderRight/RedBoulderRight.png"),
	"YELLOW": preload("res://Assets/StartMenuArt/SelectMenuBoulderRight/YellowBoulderRight.png")
	}
# Textures for each state of the health bar
var health_bar_textures = [
	preload("res://Assets/InfoOverlay/0Health.png"),
	preload("res://Assets/InfoOverlay/20Health.png"),
	preload("res://Assets/InfoOverlay/40Health.png"),
	preload("res://Assets/InfoOverlay/60Health.png"),
	preload("res://Assets/InfoOverlay/80Health.png"),
	preload("res://Assets/InfoOverlay/FullHealth.png")
	]
# Textures for the left and right side ability icons in the overlay
var p1_ability_textures = [
	preload("res://Assets/StartMenuArt/AbilityButtonLeft1/HDashLeftDefault.png"),
	preload("res://Assets/StartMenuArt/AbilityButtonLeft2/VDashLeftDefault.png"),
	preload("res://Assets/StartMenuArt/AbilityButtonLeft3/FrictionlessLeftDefault.png"),
	preload("res://Assets/StartMenuArt/AbilityButtonLeft4/GrappleLeftDefault.png"),
	preload("res://Assets/StartMenuArt/AbilityButtonLeft5/SlingshotLeftDefault.png"),
	preload("res://Assets/StartMenuArt/AbilityButtonLeft6/SpikeLeftDefault.png"),
	preload("res://Assets/StartMenuArt/BlankLeftDefault.png")
	]
var p2_ability_textures = [
	preload("res://Assets/StartMenuArt/AbilityButtonRight1/HDashRightDefault.png"),
	preload("res://Assets/StartMenuArt/AbilityButtonRight2/VDashRightDefault.png"),
	preload("res://Assets/StartMenuArt/AbilityButtonRight3/FrictionlessRightDefault.png"),
	preload("res://Assets/StartMenuArt/AbilityButtonRight4/GrappleRightDefault.png"),
	preload("res://Assets/StartMenuArt/AbilityButtonRight5/SlingshotRightDefault.png"),
	preload("res://Assets/StartMenuArt/AbilityButtonRight6/SpikeRightDefault.png"),
	preload("res://Assets/StartMenuArt/BlankRightDefault.png")
	]
# Same as above textures, except a highlighted version for showing the selected ability
var p1_ability_textures_hover = [
	preload("res://Assets/StartMenuArt/AbilityButtonLeft1/HDashLeftHover.png"),
	preload("res://Assets/StartMenuArt/AbilityButtonLeft2/VDashLeftHover.png"),
	preload("res://Assets/StartMenuArt/AbilityButtonLeft3/FrictionlessLeftHover.png"),
	preload("res://Assets/StartMenuArt/AbilityButtonLeft4/GrappleLeftHover.png"),
	preload("res://Assets/StartMenuArt/AbilityButtonLeft5/SlingshotLeftHover.png"),
	preload("res://Assets/StartMenuArt/AbilityButtonLeft6/SpikeLeftHover.png"),
	preload("res://Assets/StartMenuArt/BlankLeftHover.png")
	]
var p2_ability_textures_hover = [
	preload("res://Assets/StartMenuArt/AbilityButtonRight1/HDashRightHover.png"),
	preload("res://Assets/StartMenuArt/AbilityButtonRight2/VDashRightHover.png"),
	preload("res://Assets/StartMenuArt/AbilityButtonRight3/FrictionlessRightHover.png"),
	preload("res://Assets/StartMenuArt/AbilityButtonRight4/GrappleRightHover.png"),
	preload("res://Assets/StartMenuArt/AbilityButtonRight5/SlingshotRightHover.png"),
	preload("res://Assets/StartMenuArt/AbilityButtonRight6/SpikeRightHover.png"),
	preload("res://Assets/StartMenuArt/BlankRightHover.png")
	]


func _ready() -> void:
	# Sets the minature player icon to the same one/colour as the player
	player_1_icon.texture = p1_colour_textures[GameData.player_colour[0]]
	player_2_icon.texture = p2_colour_textures[GameData.player_colour[1]]
	
	# Sets the icons for the abilities player 1 has chosen
	for i in p1_ability_icons.size():
		var ab_icon = GameData.player_abilities[0][i]
		if ab_icon is not String:
			p1_ability_icons[i].texture = p1_ability_textures[ab_icon]
		else:
			p1_ability_icons[i].texture = p1_ability_textures[-1]
	
	# Sets the icons for the abilities player 2 has chosen
	for i in p2_ability_icons.size():
		var ab_icon = GameData.player_abilities[1][i]
		if ab_icon is not String:
			p2_ability_icons[i].texture = p2_ability_textures[ab_icon]
		else:
			p2_ability_icons[i].texture = p2_ability_textures[-1]
	
	# Updates the ability icons to highlight the selected one
	update_ability_icons(0, GameData.player_abilities[0], 0)
	update_ability_icons(1, GameData.player_abilities[1], 0)


# Updates the textures for the ability icons to highlight or remove the highlight from them
func update_ability_icons(player_index: int, abilities: Array, selected_index: int) -> void:
	var icons
	var textures
	var highlighted

	# If the player is player 1, use the player 1 related textures
	if player_index == 0:
		icons = p1_ability_icons
		textures = p1_ability_textures
		highlighted = p1_ability_textures_hover
	else:
		icons = p2_ability_icons
		textures = p2_ability_textures
		highlighted = p2_ability_textures_hover

	# Iterates through each abilitie, if it is selected, highlight it. If not, remove the highlight from it.
	for i in range(abilities.size()):
		var ability_id = abilities[i]
		if i == selected_index: 
			icons[i].texture = highlighted[ability_id] if ability_id is not String else highlighted[-1]
		else:
			icons[i].texture = textures[ability_id] if ability_id is not String else textures[-1]


# Display the texture that corresponds with the player's current health
func update_health_bar(health: int) -> Texture2D:
	if health > 800:
		return health_bar_textures[5]
	elif health > 600:
		return health_bar_textures[4]
	elif health > 400:
		return health_bar_textures[3]
	elif health > 200:
		return health_bar_textures[2]
	elif health > 0:
		return health_bar_textures[1]
	else:
		return health_bar_textures[0]


func _physics_process(delta: float) -> void:
	p1_health_bar.texture = update_health_bar(GameData.player_health[0])
	p2_health_bar.texture = update_health_bar(GameData.player_health[1])
