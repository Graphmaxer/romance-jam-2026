@tool
class_name Discussion
extends Control

signal ended(dialogue: DialogueResource)

const CHARACTER_CARD: PackedScene = preload("res://ui/character_card/character_card.tscn")

@export var story: Story

var current_dialogue: DialogueResource

@onready var background_stack: BackgroundStack = %BackgroundStack
@onready var characters_container: HBoxContainer = %CharactersContainer
@onready var background_stream_player: AudioStreamPlayer = %BackgroundStreamPlayer
@onready var transition: Transition = %Transition


func _ready() -> void:
	if not Engine.is_editor_hint():
		DialogueManager.got_dialogue.connect(_on_got_dialogue)
		DialogueManager.dialogue_ended.connect(_on_dialogue_ended)
	if story and Engine.is_editor_hint():
		for character: Character in story.characters:
			add_character(character.firstname)


func start(dialogue: DialogueResource, dialogue_cue: String) -> void:
	current_dialogue = dialogue
	DialogueManager.show_dialogue_balloon(dialogue, dialogue_cue, [self])


func set_location(alias: String, variant: String = "default") -> void:
	var location: Location = story.get_location(alias)
	if location:
		_clean_characters()
		if location.backgrounds.has(variant):
			await background_stack.update_background(
				location.backgrounds[variant],
				transition.is_transitioning(),
			)
		else:
			await background_stack.update_background(
				location.backgrounds["default"],
				transition.is_transitioning(),
			)
			push_warning("%s background at %s variant not found" % [alias, variant])
		if location.music and background_stream_player.stream != location.music:
			background_stream_player.stream = location.music
			background_stream_player.play()
	else:
		push_warning("Location to set not found: %s" % alias)


func add_character(firstname: String, variant: String = "default") -> void:
	var character: Character = story.get_character(firstname)
	if character:
		if _find_character_card(firstname):
			push_warning("Character already present: %s" % firstname)
		else:
			var character_card: CharacterCard = CHARACTER_CARD.instantiate()
			character_card.name = firstname
			character_card.character = character
			character_card.variant = variant
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


func change_variant(firstname: String, variant: String) -> void:
	var character: Character = story.get_character(firstname)
	if character:
		var character_card: CharacterCard = _find_character_card(character.firstname)
		if character_card:
			character_card.change_variant(variant)
		else:
			push_warning("Character to change variant not present: %s" % firstname)
	else:
		push_warning("Character to change variant unknown: %s" % firstname)


func show_transition(text: String, wait: float = 1.0) -> void:
	await transition.play(text, wait)


func start_transition(text: String, wait: float = 1.0) -> void:
	await transition.fade_in_and_wait(text, wait)


func end_transition() -> void:
	await transition.fade_out()


func get_reputation(firstname: String) -> float:
	return GameState.get_reputation(firstname)


func gain_reputation(firstname: String, points: int) -> void:
	_update_reputation(firstname, +points)


func lose_reputation(firstname: String, points: int) -> void:
	_update_reputation(firstname, -points)


func _update_reputation(firstname: String, points: int) -> void:
	var character_card: CharacterCard = _find_character_card(firstname)
	if character_card:
		await character_card.update_reputation(points)
	else:
		push_warning("Character to update reputation not present: %s" % firstname)


func _clean_characters() -> void:
	for character_card: CharacterCard in characters_container.get_children():
		characters_container.remove_child(character_card)
		character_card.queue_free()


func _update_focus(firstname_or_alias: String) -> void:
	var character: Character = story.get_character(firstname_or_alias)
	var character_card_to_focus: CharacterCard
	if character:
		character_card_to_focus = _find_character_card(character.firstname)
	for character_card: CharacterCard in characters_container.get_children():
		if not firstname_or_alias or character_card == character_card_to_focus:
			character_card.focus_character()
		else:
			character_card.unfocus_character()


func _find_character_card(firstname: String) -> CharacterCard:
	return characters_container.get_node_or_null(firstname)


func _on_got_dialogue(line: DialogueLine) -> void:
	if not line.character.begins_with(GameState.pseudo):
		_update_focus(line.character)
		if line.character:
			if line.tags and line.tags.size() == 1:
				change_variant(line.character, line.tags[0])
			else:
				change_variant(line.character, "default")


func _on_dialogue_ended(dialogue_ended: DialogueResource) -> void:
	if current_dialogue == dialogue_ended:
		_clean_characters()
		ended.emit(dialogue_ended)
