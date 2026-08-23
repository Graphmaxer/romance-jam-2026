extends Control

@export var prologue: DialogueResource
@export var love_interest_selection_scene: PackedScene
@export var routes: Array[Route]

var love_interest_selection_tween: Tween

var auto_save_tween: Tween

@onready var discussion: Discussion = %Discussion
@onready var auto_save: Control = %AutoSave
@onready var settings_menu: SettingsMenu = %SettingsMenu


func _ready() -> void:
	if GameState.love_interest:
		var route: Route = _get_route(GameState.love_interest)
		if GameState.chapter_number > 0:
			_start_discussion(route.get_chapter(GameState.chapter_number))
		else:
			_start_discussion(route.ending)
	elif GameState.skip_prologue:
		GameState.skip_prologue = false
		_display_love_interest_selection()
	else:
		_start_discussion(prologue)


func _start_discussion(dialogue: DialogueResource) -> void:
	auto_save_tween = TweenUtils.setup_tween(self, auto_save_tween, Tween.TRANS_CUBIC)
	auto_save_tween.tween_property(auto_save, "modulate:a", 1, 1)
	auto_save_tween.tween_property(auto_save, "modulate:a", 0, 1)
	GameState.save_game()
	discussion.start(dialogue, dialogue.first_cue)


func _get_route(character_firstname: String) -> Route:
	for route: Route in routes:
		if route.character.firstname == character_firstname:
			return route
	return null


func _get_chapter_transition_text() -> String:
	return "%s: Chapitre %d" % [GameState.love_interest, GameState.chapter_number]


func _display_love_interest_selection() -> void:
	var love_interest_selection: Control = love_interest_selection_scene.instantiate()
	love_interest_selection.modulate.a = 0
	love_interest_selection.chosen.connect(_on_love_interest_selection_chosen)
	add_child(love_interest_selection)

	love_interest_selection_tween = TweenUtils.setup_tween(
		self,
		love_interest_selection_tween,
		Tween.TRANS_SINE,
	)
	love_interest_selection_tween.tween_property(love_interest_selection, "modulate:a", 1, 1.0)


func _on_discussion_ended(dialogue_ended: DialogueResource) -> void:
	var route: Route = _get_route(GameState.love_interest)
	if dialogue_ended == prologue:
		if GameState.bad_prologue_ending:
			GameState.bad_prologue_ending = false
			get_tree().change_scene_to_file("res://main.tscn")
			return
		_display_love_interest_selection()
		discussion.end_transition()
	elif GameState.chapter_number > 0 and GameState.chapter_number <= route.chapters.size():
		if route.is_last_chapter(GameState.chapter_number):
			GameState.chapter_number = 0
			await discussion.start_transition("%s: Fin" % GameState.love_interest)
			_start_discussion(route.ending)
		else:
			GameState.chapter_number += 1
			await discussion.start_transition(_get_chapter_transition_text())
			_start_discussion(route.get_chapter(GameState.chapter_number))
		await discussion.end_transition()
	else:
		GameState.love_interest = ""
		get_tree().change_scene_to_file("res://main.tscn")


func _on_love_interest_selection_chosen(firstname: String) -> void:
	GameState.love_interest = firstname
	GameState.chapter_number = 1
	var route: Route = _get_route(GameState.love_interest)
	var love_interest_selection: Node = get_node_or_null("LoveInterestSelection")
	await discussion.start_transition(_get_chapter_transition_text())
	if love_interest_selection:
		remove_child(love_interest_selection)
		love_interest_selection.queue_free()
	_start_discussion(route.get_chapter(GameState.chapter_number))
	await discussion.end_transition()


func _on_settings_button_pressed() -> void:
	settings_menu.open()


func _on_home_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
