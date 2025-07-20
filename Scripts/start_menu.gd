extends Node2D

var maps = {
	"Map1": "res://Scenes/Map1.tscn",
	"Map2": "res://Scenes/Map2.tscn"
}

func load_map(map_name: String):
	var path = maps.get(map_name, "")
	if path != "":
		get_tree().change_scene_to_file(path)

# Some func here that handles the map selection, this will be just a func to set the var "map_selected".
# once start is pressed then "map_selected" variable will be passed into the "load_map" func and that will start it
