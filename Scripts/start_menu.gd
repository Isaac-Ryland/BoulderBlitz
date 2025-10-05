extends Node2D
## Start Menu
##
## The menu where users select their abilities, and can navigate to settings and back to the main menu

# References to Nodes in the node tree
@onready var ability_select_left: Control = $ability_select_left
@onready var ability_select_right: Control = $ability_select_right
@onready var map_select: Control = $map_select
@onready var ReadyLeft: TextureButton = $ReadyLeft/TextureButton
@onready var ReadyRight: TextureButton = $ReadyRight/TextureButton
@onready var slot_1: TextureButton = $SlotsLeft/HBoxContainer/Slot1
@onready var ability_slot_textures = [ # Ability slot textures, for showing currently selected ability
	$AbilitySlot1,
	$AbilitySlot2,
	$AbilitySlot3,
	$AbilitySlot4,
	$AbilitySlot5,
	$AbilitySlot6
	]

# Signals for changing the visibility of the pop-up menus
signal change_left_visibility()
signal change_right_visibility()
signal change_map_visibilty()


var current_slot = 0
var p1_ready = false
var p2_ready = false
var left_textures = [
	preload("res://Assets/StartMenuArt/AbilityMenuLeft/AbilityMenuLeftSlot1.png"),
	preload("res://Assets/StartMenuArt/AbilityMenuLeft/AbilityMenuLeftSlot2.png"),
	preload("res://Assets/StartMenuArt/AbilityMenuLeft/AbilityMenuLeftSlot3.png")
	]
var right_textures = [
	preload("res://Assets/StartMenuArt/AbilityMenuRight/AbilityMenuRightSlot1.png"),
	preload("res://Assets/StartMenuArt/AbilityMenuRight/AbilityMenuRightSlot2.png"),
	preload("res://Assets/StartMenuArt/AbilityMenuRight/AbilityMenuRightSlot3.png")
	]
var ability_selected_textures = [
	preload("res://Assets/StartMenuArt/HDash.png"),
	preload("res://Assets/StartMenuArt/VDash.png"),
	preload("res://Assets/StartMenuArt/Frictionless.png"),
	preload("res://Assets/StartMenuArt/Grapple.png"),
	preload("res://Assets/StartMenuArt/Slingshot.png"),
	preload("res://Assets/StartMenuArt/Spike.png")
	]


# When the menu is loaded, checks the player's abilities to put the correct icons in the slots
func _ready() -> void:
	for player_index in [0, 1]:
		for slot in range(GameData.player_abilities[player_index].size()):
			var ability = GameData.player_abilities[player_index][slot]
			if ability is not String:
				update_selected_ability_texture(player_index, slot, ability)


# If the map select menu is visible then close it, else go to the main menu
func on_back_button_pressed() -> void:
	if map_select.visible:
		change_map_visibilty.emit()
	else:
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func on_settings_button_pressed() -> void:
	GameData.settings_prev_menu = "res://Scenes/start_menu.tscn" # Sets the start menu as the previous menu so the settings menu can go back correctly
	get_tree().change_scene_to_file("res://Scenes/settings.tscn")


# Toggles the visibility of the ability select menu, and changes its texture to the respective slot
func handle_slot_press(menu, menu_visibility_signal, slot_index: int) -> void:
	if !menu.visible:
		menu_visibility_signal.emit()
	elif current_slot == slot_index:
		menu_visibility_signal.emit()
	current_slot = slot_index


# Ability slots for player 1 (left side of the menu)
func _on_slot_1_left_pressed() -> void:
	handle_slot_press(ability_select_left, change_left_visibility, 0)
	ability_select_left.set_texture(left_textures[0])
	ability_select_left.set_slot(current_slot)


func _on_slot_2_left_pressed() -> void:
	handle_slot_press(ability_select_left, change_left_visibility, 1)
	ability_select_left.set_texture(left_textures[1])
	ability_select_left.set_slot(current_slot)


func _on_slot_3_left_pressed() -> void:
	handle_slot_press(ability_select_left, change_left_visibility, 2)
	ability_select_left.set_texture(left_textures[2])
	ability_select_left.set_slot(current_slot)


# Ability slots for player 2 (right side of the menu)
func _on_slot_1_right_pressed() -> void:
	handle_slot_press(ability_select_right, change_right_visibility, 0)
	ability_select_right.set_texture(right_textures[0])
	ability_select_right.set_slot(current_slot)


func _on_slot_2_right_pressed() -> void:
	handle_slot_press(ability_select_right, change_right_visibility, 1)
	ability_select_right.set_texture(right_textures[1])
	ability_select_right.set_slot(current_slot)


func _on_slot_3_right_pressed() -> void:
	handle_slot_press(ability_select_right, change_right_visibility, 2)
	ability_select_right.set_texture(right_textures[2])
	ability_select_right.set_slot(current_slot)


# Displays the selected ability in its according slot
func update_selected_ability_texture(player_index: int, slot: int, ability: int):
	if player_index == 0:
		ability_slot_textures[slot].texture = ability_selected_textures[ability]
		ability_slot_textures[slot].visible = true
	else:
		slot += 3 # Slot is increased by three o update the slots on the right side when the player is two
		ability_slot_textures[slot].texture = ability_selected_textures[ability]
		ability_slot_textures[slot].visible = true


# Toggling the map select menu once both players are ready
func _on_ready_left_pressed() -> void:
	p1_ready = !p1_ready
	if p1_ready and p2_ready:
		change_map_visibilty.emit()


func _on_ready_right_pressed() -> void:
	p2_ready = !p2_ready
	if p1_ready and p2_ready:
		change_map_visibilty.emit()
