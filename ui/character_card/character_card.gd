@tool
class_name CharacterCard extends Control

@export var character: Character

@onready var reputation_bar: ProgressBar = $VBoxContainer/MarginContainer/ReputationBar
@onready var character_tex: TextureRect = $VBoxContainer/CharacterTex

func _ready() -> void:
	_refresh_character()

func _refresh_character() -> void:
	if character:
		reputation_bar.value = character.reputation
		character_tex.texture = character.get_face_tex()

func change_face(face: Character.Face) -> void:
	character.face = face
	_refresh_character()
