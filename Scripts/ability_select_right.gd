extends AbilitySelect


# When the menu is initialised, sets a default texture
func _ready() -> void:
	self.ability_menu_texture = $AbilityMenuRight


# Toggles the visibility of the right ability select menu
func _on_start_menu_change_visibility() -> void:
	change_visibility()
