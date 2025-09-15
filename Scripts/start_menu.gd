extends Node2D

@onready var ability_select_left: Control = $ability_select_left
@onready var ability_select_right: Control = $ability_select_right
@onready var map_select: Control = $map_select
@onready var ReadyLeft: TextureButton = $ReadyLeft/TextureButton
@onready var ReadyRight: TextureButton = $ReadyRight/TextureButton

# Ability slot textures, for showing currently selected ability
@onready var ability_slot_textures = {
	1: $AbilitySlot1,
	2: $AbilitySlot2,
	3: $AbilitySlot3,
	4: $AbilitySlot4,
	5: $AbilitySlot5,
	6: $AbilitySlot6
}

signal change_left_visibility()
signal change_right_visibility()
signal change_map_visibilty()

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
	preload("res://Assets/StartMenuArt/Ability1.png"),
	preload("res://Assets/StartMenuArt/Ability2.png"),
	preload("res://Assets/StartMenuArt/Ability3.png"),
	preload("res://Assets/StartMenuArt/Ability4.png"),
	preload("res://Assets/StartMenuArt/Ability5.png"),
	preload("res://Assets/StartMenuArt/Ability6.png")
]

var current_left_slot = 0
var current_right_slot = 0
var p1_ready = false
var p2_ready = false

# Menu Navigation buttons
func on_back_button_pressed() -> void:
	if map_select.visible:
		change_map_visibilty.emit()
	else:
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func on_settings_button_pressed() -> void:
	GameData.settings_prev_menu = "res://Scenes/start_menu.tscn"
	get_tree().change_scene_to_file("res://Scenes/settings.tscn")

# Ability slots for player 1 (left side of the menu)
func _on_slot_1_left_pressed() -> void:
	if !ability_select_left.visible:
		change_left_visibility.emit()
	elif current_left_slot == 1:
		change_left_visibility.emit()
	current_left_slot = 1
	ability_select_left.set_texture(left_textures[0], current_left_slot)

func _on_slot_2_left_pressed() -> void:
	if !ability_select_left.visible:
		change_left_visibility.emit()
	elif current_left_slot == 2:
		change_left_visibility.emit()
	current_left_slot = 2
	ability_select_left.set_texture(left_textures[1], current_left_slot)

func _on_slot_3_left_pressed() -> void:
	if !ability_select_left.visible:
		change_left_visibility.emit()
	elif current_left_slot == 3:
		change_left_visibility.emit()
	current_left_slot = 3
	ability_select_left.set_texture(left_textures[2], current_left_slot)

# Ability slots for player 2 (right side of the menu)
func _on_slot_1_right_pressed() -> void:
	if !ability_select_right.visible:
		change_right_visibility.emit()
	elif current_right_slot == 1:
		change_right_visibility.emit()
		current_right_slot = 0
	current_right_slot = 1
	ability_select_right.set_texture(right_textures[0], current_right_slot)

func _on_slot_2_right_pressed() -> void:
	if !ability_select_right.visible:
		change_right_visibility.emit()
	elif current_right_slot == 2:
		change_right_visibility.emit()
		current_right_slot = 0
	current_right_slot = 2
	ability_select_right.set_texture(right_textures[1], current_right_slot)

func _on_slot_3_right_pressed() -> void:
	if !ability_select_right.visible:
		change_right_visibility.emit()
	elif current_right_slot == 3:
		change_right_visibility.emit()
		current_right_slot = 0
	current_right_slot = 3
	ability_select_right.set_texture(right_textures[2], current_right_slot)

# Func for displaying the selected ability
func update_selected_ability(player: int, slot: int, ab: int):
	if player == 1:
		ability_slot_textures[slot].texture = ability_selected_textures[ab - 1]
		ability_slot_textures[slot].visible = true
	elif player == 2:
		slot += 3
		ability_slot_textures[slot].texture = ability_selected_textures[ab - 1]
		ability_slot_textures[slot].visible = true

# Player colour switch logic. Will not allow matching colours
#needs a var (GameData.player_#_colour) to choose arrow colour


# Starting the game once both players are ready
func _on_ready_left_pressed() -> void:
	p1_ready = !p1_ready
	if p1_ready and p2_ready:
		change_map_visibilty.emit()

func _on_ready_right_pressed() -> void:
	p2_ready = !p2_ready
	if p1_ready and p2_ready:
		change_map_visibilty.emit()
