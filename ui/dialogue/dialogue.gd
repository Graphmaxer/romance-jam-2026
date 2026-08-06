@tool
class_name Dialogue extends Control

@export var characters: Dictionary[String, Character]
@export var dialogue: DialogueResource
@export var character_card_scene: PackedScene

@onready var characters_container: HBoxContainer = $CharactersContainer

func _ready() -> void:
	for character_name in characters:
		var character_card: CharacterCard = character_card_scene.instantiate()
		character_card.character = characters[character_name]
		characters_container.add_child(character_card)
		
	if dialogue and not Engine.is_editor_hint():
		DialogueManager.show_dialogue_balloon(dialogue)

func change_face(firstname: String, face: Character.Face) -> void:
	if characters.has(firstname):
		characters[firstname].change_face(face)
