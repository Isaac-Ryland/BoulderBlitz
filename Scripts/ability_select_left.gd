extends Control

@onready var start_menu: Node2D = $".."
@onready var ability_menu_left: TextureRect = $AbilityMenuLeft
var is_visible = false
var current_slot = 0

func _on_ready() -> void:
	self.visible = is_visible

func set_texture(new_textures: Texture, slot: int) -> void:
	ability_menu_left.texture = new_textures
	current_slot = slot

func _on_start_menu_change_left_visibility() -> void:
	is_visible = !is_visible
	self.visible = is_visible

# Abilities
func _on_ability_1_pressed() -> void:
	GameData.select_ability(1, current_slot, GameData.abilities["Ab1"])
	get_parent().update_selected_ability(1, current_slot, 1)
	_on_start_menu_change_left_visibility()

func _on_ability_2_pressed() -> void:
	GameData.select_ability(1, current_slot, GameData.abilities["Ab2"])
	get_parent().update_selected_ability(1, current_slot, 2)
	_on_start_menu_change_left_visibility()

func _on_ability_3_pressed() -> void:
	GameData.select_ability(1, current_slot, GameData.abilities["Ab3"])
	get_parent().update_selected_ability(1, current_slot, 3)
	_on_start_menu_change_left_visibility()

func _on_ability_4_pressed() -> void:
	GameData.select_ability(1, current_slot, GameData.abilities["Ab4"])
	get_parent().update_selected_ability(1, current_slot, 4)
	_on_start_menu_change_left_visibility()

func _on_ability_5_pressed() -> void:
	GameData.select_ability(1, current_slot, GameData.abilities["Ab5"])
	get_parent().update_selected_ability(1, current_slot, 5)
	_on_start_menu_change_left_visibility()

func _on_ability_6_pressed() -> void:
	GameData.select_ability(1, current_slot, GameData.abilities["Ab6"])
	get_parent().update_selected_ability(1, current_slot, 6)
	_on_start_menu_change_left_visibility()
