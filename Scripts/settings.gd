extends Node2D
## Settings Menu
##
## Where the users can change the controls of their players

var p1_presets = [
	{"player_1_ability_cycle": KEY_Q, "player_1_ability_use": KEY_E},
	{"player_1_ability_cycle": KEY_E, "player_1_ability_use": KEY_Q},
	{"player_1_ability_cycle": KEY_CTRL, "player_1_ability_use": KEY_SHIFT},
	{"player_1_ability_cycle": KEY_SHIFT, "player_1_ability_use": KEY_C}
]
var p2_presets = [
	{"player_2_ability_cycle": KEY_O, "player_2_ability_use": KEY_U},
	{"player_2_ability_cycle": KEY_U, "player_2_ability_use": KEY_O},
	{"player_2_ability_cycle": KEY_SLASH, "player_2_ability_use": KEY_APOSTROPHE},
	{"player_2_ability_cycle": KEY_SLASH, "player_2_ability_use": KEY_N}
]


# Removes all assigned keys to an action before replacing them with the keys from a control preset
func apply_preset(preset: Dictionary):
	for action in preset.keys():
		InputMap.action_erase_events(action)
		
		var ev = InputEventKey.new()
		ev.physical_keycode = preset[action]
		InputMap.action_add_event(action, ev)


func on_back_button_pressed() -> void:
	get_tree().change_scene_to_file(GameData.settings_prev_menu) # Used to travel back to where the user was before


func _on_check_button_1_pressed() -> void:
	apply_preset(p1_presets[0])


func _on_check_button_2_pressed() -> void:
	apply_preset(p1_presets[1])


func _on_check_button_3_pressed() -> void:
	apply_preset(p1_presets[2])


func _on_check_button_4_pressed() -> void:
	apply_preset(p1_presets[3])


func _on_check_button_5_pressed() -> void:
	apply_preset(p2_presets[0])


func _on_check_button_6_pressed() -> void:
	apply_preset(p2_presets[1])


func _on_check_button_7_pressed() -> void:
	apply_preset(p2_presets[2])


func _on_check_button_8_pressed() -> void:
	apply_preset(p2_presets[3])
