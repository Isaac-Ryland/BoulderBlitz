extends Control

@onready var ability_select_right: Control = $"."
@onready var ability_menu_right: TextureRect = $AbilityMenuRight
var is_visible = false

func _on_ready() -> void:
	ability_select_right.visible = is_visible

func set_texture(new_textures: Texture) -> void:
	ability_menu_right.texture = new_textures

func _on_start_menu_change_right_visibility() -> void:
	is_visible = !is_visible
	ability_select_right.visible = is_visible
