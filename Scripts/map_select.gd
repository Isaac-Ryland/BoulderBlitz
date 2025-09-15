extends Control

@onready var map_1: TextureButton = $map_menu_bg/VBoxContainer/MapRow1/Map1
@onready var map_2: TextureButton = $map_menu_bg/VBoxContainer/MapRow1/Map2
@onready var map_3: TextureButton = $map_menu_bg/VBoxContainer/MapRow1/Map3

var maps = {
	"Map1": "res://Scenes/map_1.tscn",
	"Map2": "res://Scenes/map_2.tscn",
	"Map3": "res://Scenes/map_3.tscn"
}
var is_visible = false

func _on_ready() -> void:
	self.visible = is_visible

func _on_start_menu_change_map_visibilty() -> void:
	is_visible = !is_visible
	self.visible = is_visible

# Map loading
func load_map(map_name: String):
	var path = maps.get(map_name, "")
	if path != "":
		get_tree().change_scene_to_file(path)

func _on_map_1_pressed() -> void:
	load_map("Map1")

func _on_map_2_pressed() -> void:
	load_map("Map2")

func _on_map_3_pressed() -> void:
	load_map("Map3")
