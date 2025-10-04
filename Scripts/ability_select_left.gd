extends AbilitySelect


# When the menu is initialised, sets a default texture
func _ready() -> void:
	self.ability_menu_texture = $AbilityMenuLeft


# Toggles the visibility of the left ability select menu
func _on_start_menu_change_left_visibility() -> void:
	change_visibility()
