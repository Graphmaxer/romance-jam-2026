@tool
class_name DiscussionScreen
extends Control

signal discussion_ended

const CHARACTER_CARD: PackedScene = preload("res://ui/character_card/character_card.tscn")

@export var discussion: Discussion

@onready var characters_container: HBoxContainer = $CharactersContainer
@onready var background_tex_rect: TextureRect = $BackgroundTexRect
@onready var background_stream_player: AudioStreamPlayer = $BackgroundStreamPlayer


func _ready() -> void:
	setup(discussion)
	DialogueManager.connect("got_dialogue", _on_got_dialogue)
	DialogueManager.connect("dialogue_ended", _on_dialogue_ended)


func setup(discussion_to_setup: Discussion) -> void:
	if not discussion_to_setup:
		return
	discussion = discussion_to_setup
	if discussion.location and discussion.location.background:
		background_tex_rect.texture = discussion.location.background

	for character_card: CharacterCard in characters_container.get_children():
		characters_container.remove_child(character_card)
		character_card.queue_free()

	for character in discussion.characters:
		var character_card: CharacterCard = CHARACTER_CARD.instantiate()
		character_card.name = character.firstname
		character_card.character = character
		characters_container.add_child(character_card)

	if not Engine.is_editor_hint():
		if discussion.dialogue:
			DialogueManager.show_dialogue_balloon(discussion.dialogue, "start", [self])

		if discussion.location and discussion.location.music:
			background_stream_player.stream = discussion.location.music
			background_stream_player.play()


func change_face(firstname: String, face: Character.Face) -> void:
	var character_card = _find_character_card(firstname)
	if character_card:
		character_card.change_face(face)


func focus_character(firstname: String) -> void:
	var character_card_to_focus = _find_character_card(firstname)
	for character_card in characters_container.get_children():
		if character_card == character_card_to_focus:
			character_card.focus_character()
		else:
			character_card.unfocus_character()


func _find_character_card(firstname: String) -> CharacterCard:
	var character_card: CharacterCard = characters_container.get_node_or_null(firstname)
	if not character_card:
		push_warning("Character not found: %s" % firstname)
	return character_card


func _on_got_dialogue(line: DialogueLine) -> void:
	if line.character:
		focus_character(line.character)
	else:
		for character_card: CharacterCard in characters_container.get_children():
			character_card.focus_character()


func _on_dialogue_ended(dialogue_ended: DialogueResource) -> void:
	if discussion and discussion.dialogue == dialogue_ended:
		discussion_ended.emit()
