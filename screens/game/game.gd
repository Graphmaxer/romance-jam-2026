extends Control

var dialogue = preload("res://dialogues/prologue.dialogue")

@onready var discussion: Discussion = $Discussion


func _ready() -> void:
	discussion.start(dialogue, dialogue.first_title)
