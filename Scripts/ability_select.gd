extends Control
class_name AbilitySelect
## Ability Select Menu
##
## The ui where players can select their abilities

@onready var start_menu: Node2D = $".."

var ability_menu_texture
@export var is_visible = false
@export var current_slot = 0
@export var player_index = 0


# Sets the menu to invisible on game start-up
func _ready() -> void:
	self.visible = is_visible


# When called will set the texture of the menu's background to the one specified
func set_texture(new_textures: Texture, slot: int) -> void:
	ability_menu_texture.texture = new_textures
	current_slot = slot


# Toggles the visibility of the menu
func change_visibility() -> void:
	is_visible = !is_visible
	self.visible = is_visible


# Ability buttons
func _on_ability_1_pressed() -> void:
	GameData.select_ability(player_index, current_slot, 1)
	# Tells the start menu what icon to fill the slot with
	get_parent().update_selected_ability(player_index+1, current_slot, 1)
	change_visibility()


func _on_ability_2_pressed() -> void:
	GameData.select_ability(player_index, current_slot, 2)
	# Tells the start menu what icon to fill the slot with
	get_parent().update_selected_ability(player_index+1, current_slot, 2)
	change_visibility()


func _on_ability_3_pressed() -> void:
	GameData.select_ability(player_index, current_slot, 3)
	# Tells the start menu what icon to fill the slot with
	get_parent().update_selected_ability(player_index+1, current_slot, 3)
	change_visibility()


func _on_ability_4_pressed() -> void:
	GameData.select_ability(player_index, current_slot, 4)
	# Tells the start menu what icon to fill the slot with
	get_parent().update_selected_ability(player_index+1, current_slot, 4)
	change_visibility()


func _on_ability_5_pressed() -> void:
	GameData.select_ability(player_index, current_slot, 5)
	# Tells the start menu what icon to fill the slot with
	get_parent().update_selected_ability(player_index+1, current_slot, 5)
	change_visibility()


func _on_ability_6_pressed() -> void:
	GameData.select_ability(player_index, current_slot, 6)
	# Tells the start menu what icon to fill the slot with
	get_parent().update_selected_ability(player_index+1, current_slot, 6)
	change_visibility()
