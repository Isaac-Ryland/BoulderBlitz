extends Control

@onready var ability_menu_left: TextureRect = $AbilityMenuLeft
var is_visible = false

func _on_ready() -> void:
	self.visible = is_visible

func set_texture(new_textures: Texture) -> void:
	ability_menu_left.texture = new_textures

func _on_start_menu_change_left_visibility() -> void:
	is_visible = !is_visible
	self.visible = is_visible
