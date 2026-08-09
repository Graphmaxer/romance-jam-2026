@tool
extends Control

signal chosen

const LOVE_INTEREST_PANEL: PackedScene = preload(
	"res://ui/love_interest_panel/love_interest_panel.tscn"
)

@export var story: Story

@onready var panels_container: HBoxContainer = $MarginContainer/PanelsContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for character_name in story.characters:
		var character: Character = story.characters[character_name]
		if character.is_love_interest:
			var panel: LoveInterestPanel = LOVE_INTEREST_PANEL.instantiate()
			panel.name = character_name
			panel.character = character
			panel.connect("chosen", _on_love_interest_choosed)
			panels_container.add_child(panel)


func _on_love_interest_choosed(character_name: String) -> void:
	chosen.emit(character_name)
