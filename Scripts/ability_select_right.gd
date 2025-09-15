extends Control

@onready var start_menu: Node2D = $".."
@onready var ability_menu_right: TextureRect = $AbilityMenuRight
var is_visible = false
var current_slot = 0

# Sets the menu to invisible on game start-up
func _on_ready() -> void:
	self.visible = is_visible

# When called will set the texture of the menu's background to the one specified
func set_texture(new_textures: Texture, slot: int) -> void:
	ability_menu_right.texture = new_textures
	current_slot = slot

# Toggles the visibility of the menu
func _on_start_menu_change_right_visibility() -> void:
	is_visible = !is_visible
	self.visible = is_visible

# Abilities
func _on_ability_1_pressed() -> void:
	GameData.select_ability(2, current_slot, GameData.abilities["Ab1"])
	# Tells the start menu what icon to fill the slot with
	get_parent().update_selected_ability(2, current_slot, 1)
	_on_start_menu_change_right_visibility()

func _on_ability_2_pressed() -> void:
	GameData.select_ability(2, current_slot, GameData.abilities["Ab2"])
	# Tells the start menu what icon to fill the slot with
	get_parent().update_selected_ability(2, current_slot, 2)
	_on_start_menu_change_right_visibility()

func _on_ability_3_pressed() -> void:
	GameData.select_ability(2, current_slot, GameData.abilities["Ab3"])
	# Tells the start menu what icon to fill the slot with
	get_parent().update_selected_ability(2, current_slot, 3)
	_on_start_menu_change_right_visibility()

func _on_ability_4_pressed() -> void:
	GameData.select_ability(2, current_slot, GameData.abilities["Ab4"])
	# Tells the start menu what icon to fill the slot with
	get_parent().update_selected_ability(2, current_slot, 4)
	_on_start_menu_change_right_visibility()

func _on_ability_5_pressed() -> void:
	GameData.select_ability(2, current_slot, GameData.abilities["Ab5"])
	# Tells the start menu what icon to fill the slot with
	get_parent().update_selected_ability(2, current_slot, 5)
	_on_start_menu_change_right_visibility()

func _on_ability_6_pressed() -> void:
	GameData.select_ability(2, current_slot, GameData.abilities["Ab6"])
	# You get the idea now
	get_parent().update_selected_ability(2, current_slot, 6)
	_on_start_menu_change_right_visibility()
