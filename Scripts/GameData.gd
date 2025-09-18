extends Node

var player_1_colour = "PURPLE"
var player_1_abilities = ["", "", ""]
var player_1_health = 1000
var player_2_colour = "RED"
var player_2_abilities = ["", "", ""]
var player_2_health = 1000

var settings_prev_menu = "res://Scenes/main_menu.tscn"

var map_selected = "res://Scenes/Map1.tscn"

var abilities = {
	1: preload("res://Scenes/ab_1.tscn"),
	3: preload("res://Scenes/ab_3.tscn"),
	2: preload("res://Scenes/ab_2.tscn"),
	4: preload("res://Scenes/ab_4.tscn"),
	5: preload("res://Scenes/ab_5.tscn"),
	6: preload("res://Scenes/ab_6.tscn")
}

# Takes the ability selected and in which slot, before assigning it to the player_x_abilities array
func select_ability(player: int, slot: int, ability) -> void:
	if player == 1:
		player_1_abilities[(slot - 1)] = ability
	elif player == 2:
		player_2_abilities[(slot - 1)] = ability

# Hotkey for returning to the main menu, anywhere
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("main_menu"): 
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
