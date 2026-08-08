extends Control

@onready var new_game_button: Button = $MarginContainer/VBoxContainer/NewGameButton


func _ready() -> void:
	pass


func start_game() -> void:
	get_tree().change_scene_to_file("res://screens/game/game.tscn")


func _on_new_game_button_pressed() -> void:
	start_game()


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_pseudo_input_text_submitted(new_text: String) -> void:
	if new_text.strip_edges().length() > 0:
		start_game()


func _on_pseudo_input_text_changed(new_text: String) -> void:
	GameState.pseudo = new_text
	if new_text.strip_edges().length() > 0:
		new_game_button.disabled = false
	else:
		new_game_button.disabled = true
