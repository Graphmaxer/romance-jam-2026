@tool
class_name Discussion
extends Control

signal discussion_ended

const CHARACTER_CARD: PackedScene = preload("res://ui/character_card/character_card.tscn")

@export var story: Story

@onready var characters_container: HBoxContainer = $CharactersContainer
@onready var background_tex_rect: TextureRect = $BackgroundTexRect
@onready var background_stream_player: AudioStreamPlayer = $BackgroundStreamPlayer
@onready var transition: CanvasLayer = $Transition

var pseudo = "Test"

var current_dialogue: DialogueResource


func _ready() -> void:
	DialogueManager.connect("passed_title", _on_passed_title)
	DialogueManager.connect("got_dialogue", _on_got_dialogue)
	DialogueManager.connect("dialogue_ended", _on_dialogue_ended)


func start(dialogue: DialogueResource, dialogue_title: String) -> void:
	current_dialogue = dialogue
	DialogueManager.show_dialogue_balloon(dialogue, dialogue_title, [self])


func set_location(location_name: String, time: String = "daytime"):
	if story and story.locations.has(location_name):
		var location: Location = story.locations[location_name]
		if location.backgrounds.has(time):
			background_tex_rect.texture = location.backgrounds[time]
		else:
			push_warning("%s background at %s time not found" % [location_name, time])
		if location.music:
			background_stream_player.stream = location.music
			background_stream_player.play()
	else:
		push_warning("Location to set not found: %s" % location_name)


func add_character(firstname: String) -> void:
	if story and story.characters.has(firstname):
		if _find_character_card(firstname):
			push_warning("Character already present: %s" % firstname)
		else:
			var character_card: CharacterCard = CHARACTER_CARD.instantiate()
			character_card.name = firstname
			character_card.character = story.characters[firstname]
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
	transition.start_transition(text)


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


func _on_passed_title(_title: String) -> void:
	_clean_characters()


func _on_got_dialogue(line: DialogueLine) -> void:
	_update_focus(line.character)


func _on_dialogue_ended(dialogue_ended: DialogueResource) -> void:
	if current_dialogue == dialogue_ended:
		_clean_characters()
		discussion_ended.emit()
