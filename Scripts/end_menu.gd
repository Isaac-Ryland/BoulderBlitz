extends Control

# Reference to the label node in the node tree
@onready var winner_label: Label = $WinnerLabel
@onready var wins_text: Label = $WinsText


# When the menu is run, checks which player won and displays respective text
func _ready() -> void:
	print("Thanks for playing!! :D")
	if GameData.loser == 0:
		winner_label.text = "Player 2 Has Won!!"
		GameData.player_2_wins += 1
		wins_text.text = "Player 2 Has %s Win(s)" % GameData.player_2_wins
	if GameData.loser == 1:
		winner_label.text = "Player 1 Has Won!!"
		GameData.player_1_wins += 1
		wins_text.text = "Player 1 Has %s Win(s)" % GameData.player_1_wins


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/start_menu.tscn")
