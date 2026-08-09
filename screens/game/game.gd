extends Control

@export var prologue: DialogueResource
@export var love_interest_selection_scene: PackedScene
@export var routes: Array[Route]

var love_interest_selection_tween: Tween

@onready var discussion: Discussion = $Discussion


func _ready() -> void:
	_start_discussion()


func _start_discussion() -> void:
	var dialogue: DialogueResource = prologue
	if GameState.love_interest and GameState.chapter_number:
		var route: Route = _get_route(GameState.love_interest)
		if route:
			dialogue = route.chapters[GameState.chapter_number - 1]
	discussion.start(dialogue, dialogue.first_title)


func _get_route(character_firstname) -> Route:
	for route: Route in routes:
		if route.character.firstname == character_firstname:
			return route
	return null


func _get_chapter_transition_text() -> String:
	return "%s: Chapitre %s" % [GameState.love_interest, GameState.chapter_number]


func _on_discussion_ended(dialogue: DialogueResource) -> void:
	var route: Route = _get_route(GameState.love_interest)
	if dialogue == prologue:
		var love_interest_selection: Control = love_interest_selection_scene.instantiate()
		love_interest_selection.modulate.a = 0
		love_interest_selection.connect("chosen", _on_love_interest_selection_chosen)
		add_child(love_interest_selection)

		if love_interest_selection_tween and love_interest_selection_tween.is_valid():
			love_interest_selection_tween.kill()
		love_interest_selection_tween = create_tween()
		love_interest_selection_tween.set_trans(Tween.TRANS_SINE)
		love_interest_selection_tween.set_ease(Tween.EASE_IN_OUT)
		love_interest_selection_tween.tween_property(love_interest_selection, "modulate:a", 1, 1.0)
	elif GameState.chapter_number < route.chapters.size():
		GameState.chapter_number += 1
		await discussion.show_transition(_get_chapter_transition_text())
		_start_discussion()
	else:
		get_tree().change_scene_to_file("res://main.tscn")


func _on_love_interest_selection_chosen(firstname: String) -> void:
	GameState.love_interest = firstname
	GameState.chapter_number = 1

	var love_interest_selection: Node = get_node_or_null("LoveInterestSelection")
	await discussion.start_transition(_get_chapter_transition_text())
	if love_interest_selection:
		remove_child(love_interest_selection)
		love_interest_selection.queue_free()
	_start_discussion()
	discussion.end_transition()
