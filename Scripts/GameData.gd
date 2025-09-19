extends Node
## GameData
##
## Stores global variables and functions, as well as important game data

var settings_prev_menu = "res://Scenes/main_menu.tscn"
var map_selected = "res://Scenes/Map1.tscn"

var player_health = [1000, 1000]
var player_colour = ["RED", "PURPLE"]
var player_abilities = [["", "", ""], ["", "", ""]]
var player_controls = [
	{
		"left": "player_1_left",
		"right": "player_1_right",
		"jump": "player_1_jump",
		"fall": "player_1_fall",
		"cycle": "player_1_ability_cycle",
		"use": "player_1_ability_use"
	},
	{
		"left": "player_2_left",
		"right": "player_2_right",
		"jump": "player_2_jump",
		"fall": "player_2_fall",
		"cycle": "player_2_ability_cycle",
		"use": "player_2_ability_use"
	}
]

var abilities = {
	1: preload("res://Scenes/ab_1.tscn"),
	3: preload("res://Scenes/ab_3.tscn"),
	2: preload("res://Scenes/ab_2.tscn"),
	4: preload("res://Scenes/ab_4.tscn"),
	5: preload("res://Scenes/ab_5.tscn"),
	6: preload("res://Scenes/ab_6.tscn")
}


# Takes the ability selected and in which slot, before assigning it to the player_x_abilities array
func select_ability(player_index: int, slot: int, ability) -> void:
	player_abilities[player_index][slot-1] = ability


# Hotkey for returning to the main menu, anywhere
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("main_menu"): 
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
