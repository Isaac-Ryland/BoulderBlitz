extends Node2D


func on_quit_button_pressed() -> void:
	get_tree().quit()

func on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/start_menu.tscn")

func on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/settings.tscn")

func on_credit_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/credits.tscn")

func on_secret_button_pressed() -> void:
	pass # Replace with function body.
