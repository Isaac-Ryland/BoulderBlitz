extends Node2D

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

func apply_preset(preset: Dictionary):
	for action in preset.keys():
		InputMap.action_erase_events(action)
		
		var ev = InputEventKey.new()
		ev.physical_keycode = preset[action]
		InputMap.action_add_event(action, ev)

func on_back_button_pressed() -> void:
	get_tree().change_scene_to_file(GameData.settings_prev_menu)


func _on_check_button_1_pressed() -> void:
	GameData.player_1_control_preset = 0
	apply_preset(p1_presets[GameData.player_1_control_preset])
	
func _on_check_button_2_pressed() -> void:
	GameData.player_1_control_preset = 1
	apply_preset(p1_presets[GameData.player_1_control_preset])
	
func _on_check_button_3_pressed() -> void:
	GameData.player_1_control_preset = 2
	apply_preset(p1_presets[GameData.player_1_control_preset])
	
func _on_check_button_4_pressed() -> void:
	GameData.player_1_control_preset = 3
	apply_preset(p1_presets[GameData.player_1_control_preset])

func _on_check_button_5_pressed() -> void:
	GameData.player_2_control_preset = 0
	apply_preset(p2_presets[GameData.player_2_control_preset])
	
func _on_check_button_6_pressed() -> void:
	GameData.player_2_control_preset = 1
	apply_preset(p2_presets[GameData.player_2_control_preset])
	
func _on_check_button_7_pressed() -> void:
	GameData.player_2_control_preset = 2
	apply_preset(p2_presets[GameData.player_2_control_preset])
	
func _on_check_button_8_pressed() -> void:
	GameData.player_2_control_preset = 3
	apply_preset(p2_presets[GameData.player_2_control_preset])
	
