extends Control

@onready var player_1_icon: TextureRect = $Control/P1
@onready var player_2_icon: TextureRect = $Control2/P2
@onready var p1_health_bar: TextureRect = $Control/HealthBar
@onready var p2_health_bar: TextureRect = $Control2/HealthBar

@onready var p1_ability_icons = {
	1: $Control/P1Abilities/Ab1,
	2: $Control/P1Abilities/Ab2,
	3: $Control/P1Abilities/Ab3
}
@onready var p2_ability_icons = {
	1: $Control2/P2Abilities/Ab1,
	2: $Control2/P2Abilities/Ab2,
	3: $Control2/P2Abilities/Ab3
}
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
var health_bar_textures = [
	preload("res://Assets/InfoOverlay/0Health.png"),
	preload("res://Assets/InfoOverlay/20Health.png"),
	preload("res://Assets/InfoOverlay/40Health.png"),
	preload("res://Assets/InfoOverlay/60Health.png"),
	preload("res://Assets/InfoOverlay/80Health.png"),
	preload("res://Assets/InfoOverlay/FullHealth.png")
]
var p1_ability_textures = {
	1: preload("res://Assets/StartMenuArt/AbilityButtonLeft1/HDashLeftDefault.png"),
	2: preload("res://Assets/StartMenuArt/AbilityButtonLeft2/VDashLeftDefault.png"),
	3: preload("res://Assets/StartMenuArt/AbilityButtonLeft3/FrictionlessLeftDefault.png"),
	4: preload("res://Assets/StartMenuArt/AbilityButtonLeft4/GrappleLeftDefault.png"),
	5: preload("res://Assets/StartMenuArt/AbilityButtonLeft5/SlingshotLeftDefault.png"),
	6: preload("res://Assets/StartMenuArt/AbilityButtonLeft6/SpikeLeftDefault.png")
}
var p2_ability_textures = {
	1: preload("res://Assets/StartMenuArt/AbilityButtonRight1/HDashRightDefault.png"),
	2: preload("res://Assets/StartMenuArt/AbilityButtonRight2/VDashRightDefault.png"),
	3: preload("res://Assets/StartMenuArt/AbilityButtonRight3/FrictionlessRightDefault.png"),
	4: preload("res://Assets/StartMenuArt/AbilityButtonRight4/GrappleRightDefault.png"),
	5: preload("res://Assets/StartMenuArt/AbilityButtonRight5/SlingshotRightDefault.png"),
	6: preload("res://Assets/StartMenuArt/AbilityButtonRight6/SpikeRightDefault.png")
}
var p1_ability_textures_hover = {
	1: preload("res://Assets/StartMenuArt/AbilityButtonLeft1/HDashLeftHover.png"),
	2: preload("res://Assets/StartMenuArt/AbilityButtonLeft2/VDashLeftHover.png"),
	3: preload("res://Assets/StartMenuArt/AbilityButtonLeft3/FrictionlessLeftHover.png"),
	4: preload("res://Assets/StartMenuArt/AbilityButtonLeft4/GrappleLeftHover.png"),
	5: preload("res://Assets/StartMenuArt/AbilityButtonLeft5/SlingshotLeftHover.png"),
	6: preload("res://Assets/StartMenuArt/AbilityButtonLeft6/SpikeLeftHover.png")
}
var p2_ability_textures_hover = {
	1: preload("res://Assets/StartMenuArt/AbilityButtonRight1/HDashRightHover.png"),
	2: preload("res://Assets/StartMenuArt/AbilityButtonRight2/VDashRightHover.png"),
	3: preload("res://Assets/StartMenuArt/AbilityButtonRight3/FrictionlessRightHover.png"),
	4: preload("res://Assets/StartMenuArt/AbilityButtonRight4/GrappleRightHover.png"),
	5: preload("res://Assets/StartMenuArt/AbilityButtonRight5/SlingshotRightHover.png"),
	6: preload("res://Assets/StartMenuArt/AbilityButtonRight6/SpikeRightHover.png")
}

func _ready() -> void:
	player_1_icon.texture = p1_colour_textures[GameData.player_1_colour]
	player_2_icon.texture = p2_colour_textures[GameData.player_2_colour]
	
	for i in p1_ability_icons.size():
		var ab_icon = GameData.player_1_abilities[i]
		p1_ability_icons[i+1].texture = p1_ability_textures[ab_icon]
	
	for i in p2_ability_icons.size():
		var ab_icon = GameData.player_2_abilities[i]
		p2_ability_icons[i+1].texture = p2_ability_textures[ab_icon]

func update_ability_icons(p: int, abilities: Array, selected_index: int) -> void:
	var icons
	var textures
	var highlighted

	if p == 1:
		icons = p1_ability_icons
		textures = p1_ability_textures
		highlighted = p1_ability_textures_hover
	else:
		icons = p2_ability_icons
		textures = p2_ability_textures
		highlighted = p2_ability_textures_hover

	for i in range(abilities.size()):
		var ability_id = abilities[i]
		if i == selected_index:
			icons[i+1].texture = highlighted[ability_id]
		else:
			icons[i+1].texture = textures[ability_id]

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
	p1_health_bar.texture = update_health_bar(GameData.player_1_health)
	p2_health_bar.texture = update_health_bar(GameData.player_2_health)
