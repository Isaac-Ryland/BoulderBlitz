extends Node2D

func on_back_button_pressed() -> void:
	get_tree().change_scene_to_file(GameData.settings_prev_menu)
