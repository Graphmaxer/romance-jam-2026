@tool
class_name Discussion
extends Control

signal ended

const CHARACTER_CARD: PackedScene = preload("res://ui/character_card/character_card.tscn")

@export var story: Story

var current_dialogue: DialogueResource

@onready var characters_container: HBoxContainer = $CharactersContainer
@onready var background_stack: BackgroundStack = $BackgroundStack
@onready var background_stream_player: AudioStreamPlayer = $BackgroundStreamPlayer
@onready var transition: Transition = $Transition


func _ready() -> void:
	DialogueManager.connect("got_dialogue", _on_got_dialogue)
	DialogueManager.connect("dialogue_ended", _on_dialogue_ended)

	if story and Engine.is_editor_hint():
		for character: Character in story.characters:
			add_character(character.firstname)


func start(dialogue: DialogueResource, dialogue_title: String) -> void:
	current_dialogue = dialogue
	DialogueManager.show_dialogue_balloon(dialogue, dialogue_title, [self])


func set_location(name: String, time: String = "daytime"):
	var location = story.get_location(name)
	if location:
		_clean_characters()
		if location.backgrounds.has(time):
			await background_stack.update_background(
				location.backgrounds[time],
				transition.is_transitioning(),
			)
		else:
			push_warning("%s background at %s time not found" % [name, time])
		if location.music:
			background_stream_player.stream = location.music
			background_stream_player.play()
	else:
		push_warning("Location to set not found: %s" % name)


func add_character(firstname: String) -> void:
	var character = story.get_character(firstname)
	if character:
		if _find_character_card(firstname):
			push_warning("Character already present: %s" % firstname)
		else:
			var character_card: CharacterCard = CHARACTER_CARD.instantiate()
			character_card.name = firstname
			character_card.character = character
			characters_container.add_child(character_card)
	else:
		push_warning("Character to add not found: %s" % firstname)


func remove_character(firstname: String) -> void:
	var character_card: CharacterCard = _find_character_card(firstname)
	if character_card:
		characters_container.remove_child(character_card)
		character_card.queue_free()
	else:
		push_warning("Character to remove not present: %s" % firstname)


func change_face(firstname: String, face: Character.Face) -> void:
	var character_card = _find_character_card(firstname)
	if character_card:
		character_card.change_face(face)
	else:
		push_warning("Character to change face not present: %s" % firstname)


func show_transition(text: String) -> void:
	await transition.play(text)


func start_transition(text: String) -> void:
	await transition.fade_in(text)


func end_transition() -> void:
	await transition.fade_out()


func get_reputation(firstname: String) -> int:
	return GameState.get_reputation(firstname)


func gain_reputation(firstname: String, points: int) -> void:
	_update_reputation(firstname, +points)


func lose_reputation(firstname: String, points: int) -> void:
	_update_reputation(firstname, -points)


func _update_reputation(firstname: String, points: int) -> void:
	var character_card = _find_character_card(firstname)
	if character_card:
		character_card.update_reputation(points)
	else:
		push_warning("Character to update reputation not present: %s" % firstname)


func _clean_characters() -> void:
	for character_card: CharacterCard in characters_container.get_children():
		characters_container.remove_child(character_card)
		character_card.queue_free()


func _update_focus(firstname: String) -> void:
	var character_card_to_focus = _find_character_card(firstname)
	for character_card in characters_container.get_children():
		if not firstname or character_card == character_card_to_focus:
			character_card.focus_character()
		else:
			character_card.unfocus_character()


func _find_character_card(firstname: String) -> CharacterCard:
	return characters_container.get_node_or_null(firstname)


func _on_got_dialogue(line: DialogueLine) -> void:
	_update_focus(line.character)


func _on_dialogue_ended(dialogue_ended: DialogueResource) -> void:
	if current_dialogue == dialogue_ended:
		_clean_characters()
		ended.emit(dialogue_ended)
