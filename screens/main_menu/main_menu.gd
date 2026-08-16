extends Control

@onready var new_game_button: Button = %NewGameButton
@onready var continue_button: Button = %ContinueButton


func _ready() -> void:
	if GameState.has_save():
		continue_button.disabled = false
		continue_button.text = "Continuer\n(%s)" % GameState.get_save_preview()


func start_game() -> void:
	get_tree().change_scene_to_file("res://screens/game/game.tscn")


func _on_new_game_button_pressed() -> void:
	GameState.love_interest = ""
	GameState.chapter_number = 0
	start_game()


func _on_quit_button_pressed() -> void:
	get_tree().quit()


func _on_pseudo_input_text_submitted(new_text: String) -> void:
	if new_text.strip_edges().length() > 0:
		start_game()


func _on_pseudo_input_text_changed(new_text: String) -> void:
	GameState.pseudo = new_text.strip_edges()
	if new_text.strip_edges().length() > 0:
		new_game_button.disabled = false
	else:
		new_game_button.disabled = true


func _on_continue_button_pressed() -> void:
	GameState.load_game()
	start_game()
