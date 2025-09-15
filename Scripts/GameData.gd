extends Node

var player_1_colour = "GREEN"
var player_2_colour = "BLUE"
var player_1_abilities = ["", "", ""]
var player_2_abilities = ["", "", ""]
var player_1_control_preset = 0
var player_2_control_preset = 0

var settings_prev_menu = "res://Scenes/main_menu.tscn"

var map_selected = "res://Scenes/Map1.tscn"

var abilities = {
	"Ab1": preload("res://Scenes/ab_1.tscn"),
	"Ab2": preload("res://Scenes/ab_2.tscn"),
	"Ab3": preload("res://Scenes/ab_3.tscn"),
	"Ab4": preload("res://Scenes/ab_4.tscn"),
	"Ab5": preload("res://Scenes/ab_5.tscn"),
	"Ab6": preload("res://Scenes/ab_6.tscn")
}

func select_ability(player: int, slot: int, ab) -> void:
	if player == 1:
		player_1_abilities[(slot - 1)] = ab
	elif player == 2:
		player_2_abilities[(slot - 1)] = ab
	else:
		print("Player ability selection error")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("main_menu"): # Hotkey for returning to the main menu, anywhere.
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
