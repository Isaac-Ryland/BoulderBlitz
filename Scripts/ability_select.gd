extends Control
class_name AbilitySelect
## Ability Select Menu
##
## The ui where players can select their abilities

@onready var start_menu: Node2D = $".." # Gets the parent menu

var ability_menu_texture
@export var is_visible = false # Flag to toggle the ability select menu visible or invisible
@export var current_slot = 0 # The current slot for which the ability is being chosen for
@export var player_index = 0 # Used to know what player to update


# Sets the menu to invisible on game start-up
func _ready() -> void:
	self.visible = is_visible


# Sets the texture of the ability select menu's background
func set_texture(new_textures: Texture) -> void:
	ability_menu_texture.texture = new_textures


func set_slot(slot: int) -> void:
	current_slot = slot


# Toggles the visibility of the ability select menu
func change_visibility() -> void:
	is_visible = !is_visible
	self.visible = is_visible


func handle_button_press(button_index):
	GameData.select_ability(player_index, current_slot, button_index)
	# Tells the start menu what icon to fill the slot with
	get_parent().update_selected_ability(player_index, current_slot, button_index)
	change_visibility()


# The following functions are for the respective ability button
func _on_ability_1_pressed() -> void:
	handle_button_press(0)


func _on_ability_2_pressed() -> void:
	handle_button_press(1)


func _on_ability_3_pressed() -> void:
	handle_button_press(2)


func _on_ability_4_pressed() -> void:
	handle_button_press(3)


func _on_ability_5_pressed() -> void:
	handle_button_press(4)


func _on_ability_6_pressed() -> void:
	handle_button_press(5)
