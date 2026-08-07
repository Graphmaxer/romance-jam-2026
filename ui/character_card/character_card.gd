@tool
class_name CharacterCard
extends Control

@export var character: Character

var character_tween: Tween

@onready var reputation_bar: ProgressBar = $VBoxContainer/MarginContainer/ReputationBar
@onready var character_tex_rect: TextureRect = $VBoxContainer/CharacterTexRect


func _ready() -> void:
	_refresh_character()


func change_face(face: Character.Face) -> void:
	character.face = face
	_refresh_character()


func focus_character() -> void:
	_modulate_character(Color.WHITE, Vector2(1.05, 1.05))


func unfocus_character() -> void:
	_modulate_character(Color.WHITE.darkened(0.25), Vector2.ONE)


func _refresh_character() -> void:
	if character:
		reputation_bar.value = character.reputation
		character_tex_rect.texture = character.get_face_tex()


func _modulate_character(color: Color, scale_vec: Vector2) -> void:
	if character_tween and character_tween.is_valid():
		character_tween.kill()
	character_tween = create_tween()
	character_tween.set_parallel()
	character_tween.set_ease(Tween.EASE_IN_OUT)
	character_tween.tween_property(character_tex_rect, "self_modulate", color, 0.15)
	character_tween.tween_property(character_tex_rect, "offset_transform_scale", scale_vec, 0.1)
