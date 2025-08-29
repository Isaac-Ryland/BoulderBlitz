extends Node2D

@onready var ability_select_left: Control = $ability_select_left
@onready var ability_select_right: Control = $ability_select_right
@onready var map_select: Control = $map_select
@onready var ReadyLeft: TextureButton = $ReadyLeft/TextureButton
@onready var ReadyRight: TextureButton = $ReadyRight/TextureButton

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
	ability_select_left.set_texture(left_textures[0])
	if !ability_select_left.visible:
		change_left_visibility.emit()
	elif current_left_slot == 1:
		change_left_visibility.emit()
		current_left_slot = 0
	current_left_slot = 1

func _on_slot_2_left_pressed() -> void:
	ability_select_left.set_texture(left_textures[1])
	if !ability_select_left.visible:
		change_left_visibility.emit()
	elif current_left_slot == 2:
		change_left_visibility.emit()
		current_left_slot = 0
	current_left_slot = 2

func _on_slot_3_left_pressed() -> void:
	ability_select_left.set_texture(left_textures[2])
	if !ability_select_left.visible:
		change_left_visibility.emit()
	elif current_left_slot == 3:
		change_left_visibility.emit()
		current_left_slot = 0
	current_left_slot = 3

# Ability slots for player 2 (right side of the menu)
func _on_slot_1_right_pressed() -> void:
	ability_select_right.set_texture(right_textures[0])
	if !ability_select_right.visible:
		change_right_visibility.emit()
	elif current_right_slot == 1:
		change_right_visibility.emit()
		current_right_slot = 0
	current_right_slot = 1

func _on_slot_2_right_pressed() -> void:
	ability_select_right.set_texture(right_textures[1])
	if !ability_select_right.visible:
		change_right_visibility.emit()
	elif current_right_slot == 2:
		change_right_visibility.emit()
		current_right_slot = 0
	current_right_slot = 2

func _on_slot_3_right_pressed() -> void:
	ability_select_right.set_texture(right_textures[2])
	if !ability_select_right.visible:
		change_right_visibility.emit()
	elif current_right_slot == 3:
		change_right_visibility.emit()
		current_right_slot = 0
	current_right_slot = 3

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
