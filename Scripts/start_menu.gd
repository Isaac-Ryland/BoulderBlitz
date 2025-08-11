extends Node2D

@onready var ability_select_left: Control = $ability_select_left
@onready var ability_select_right: Control = $ability_select_right

var maps = {
	"Map1": "res://Scenes/Map1.tscn",
	"Map2": "res://Scenes/Map2.tscn"
}
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
signal change_left_visibility()
signal change_right_visibility()
var current_left_slot = 0
var current_right_slot = 0

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


func on_temp_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Map1.tscn")


func load_map(map_name: String):
	var path = maps.get(map_name, "")
	if path != "":
		get_tree().change_scene_to_file(path)

# Some func here that handles the map selection, this will be just a func to set the
# var "map_selected". Once start is pressed then "map_selected" variable will be
# passed into the "load_map" func and that will start it
