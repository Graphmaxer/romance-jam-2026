@tool
extends Control

signal chosen

const LOVE_INTEREST_PANEL: PackedScene = preload(
	"res://ui/love_interest_panel/love_interest_panel.tscn"
)

@export var story: Story

@onready var panels_container: HBoxContainer = %PanelsContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for character: Character in story.characters:
		if character.is_love_interest:
			var panel: LoveInterestPanel = LOVE_INTEREST_PANEL.instantiate()
			panel.name = character.firstname
			panel.character = character
			panel.chosen.connect(_on_love_interest_choosed)
			panels_container.add_child(panel)


func _on_love_interest_choosed(firstname: String) -> void:
	chosen.emit(firstname)
