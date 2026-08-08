extends Control

var prologue = preload("res://dialogues/prologue.dialogue")

@onready var discussion: Discussion = $Discussion


func _ready() -> void:
	GameState.progression = "prologue"
	discussion.start(prologue, prologue.first_title)


func _on_discussion_ended() -> void:
	pass # Replace with function body.
