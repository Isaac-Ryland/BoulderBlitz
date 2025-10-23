extends Node
## GameData
##
## Stores global variables and functions, as well as important game data

const death_time = 5

# Default scenes
var settings_prev_menu = "res://Scenes/main_menu.tscn"
var map_selected = "res://Scenes/Map1.tscn"
# Player data
var player_health = [1000, 1000]
var player_colour = ["GREEN", "BLUE"]
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
var player_last_velocity = [Vector2(0,0), Vector2(0,0)] # Used for damage calculation, Storing last vel to do the calc with pre-collision speeds
var loser = null
var player_1_wins = 0
var player_2_wins = 0
var game_over = false


# Takes the ability selected and in which slot, before assigning it to the player
func select_ability(player_index: int, slot: int, ability) -> void:
	player_abilities[player_index][slot] = ability


# Hotkey for returning to the main menu from anywhere
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("main_menu"): 
		get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_timer_timeout():
	get_tree().change_scene_to_file("res://Scenes/end_menu.tscn")


func _physics_process(delta: float) -> void:
	if GameData.game_over:
		GameData.game_over = false
		var timer = get_tree().create_timer(death_time)
		timer.timeout.connect(_on_timer_timeout)
