extends AbilitySelect

func _ready() -> void:
	self.ability_menu_texture = $AbilityMenuRight

# Toggles the visibility of the menu
func _on_start_menu_change_right_visibility() -> void:
	change_visibility()
