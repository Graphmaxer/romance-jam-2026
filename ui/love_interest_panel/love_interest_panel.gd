@tool
class_name LoveInterestPanel
extends Control

@export var character: Character

@onready var infos_label: Label = $Panel/PanelMargin/VBox/InfosLabel
@onready var character_tex_rect: TextureRect = $Panel/PanelMargin/VBox/CharacterTexRect


func _ready() -> void:
	if character:
		infos_label.text = "Prénom: %s\nÂge: %d ans\nAnniversaire: %s\nTaille: %s" % [
			character.firstname,
			character.age,
			character.birthday,
			character.height,
		]
		character_tex_rect.texture = character.neutral_face
