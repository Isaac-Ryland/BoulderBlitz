extends Node2D
## Credits Menu
##
## The menu that displays the credits of our game


# Used to travel back to the main menu
func on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
