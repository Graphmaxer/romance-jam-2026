@tool
class_name LoveInterestPanel
extends Control

signal chosen

@export var character: Character

@onready var firstname_label: Label = %FirstnameLabel
@onready var infos_label: Label = %InfosLabel
@onready var description_label: Label = %DescriptionLabel
@onready var character_tex_rect: TextureRect = %CharacterTexRect


func _ready() -> void:
	if character:
		firstname_label.text = character.firstname
		infos_label.text = "%d ans\nAnniversaire le %s" % [character.age, character.birthday]
		description_label.text = character.description
		character_tex_rect.texture = character.get_variant_tex()


func _on_choose_button_pressed() -> void:
	chosen.emit(character.firstname)
