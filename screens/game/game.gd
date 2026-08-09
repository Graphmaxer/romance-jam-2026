extends Control

const PROLOGUE: DialogueResource = preload("res://dialogues/prologue.dialogue")

@onready var discussion: Discussion = $Discussion


func _ready() -> void:
	GameState.progression = "prologue"
	discussion.start(PROLOGUE, PROLOGUE.first_title)


func _on_discussion_ended() -> void:
	get_tree().change_scene_to_file(
		"res://screens/love_interest_selection/love_interest_selection.tscn"
	)
