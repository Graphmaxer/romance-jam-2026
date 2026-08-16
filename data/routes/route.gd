class_name Route
extends Resource

@export var character: Character
@export var chapters: Array[DialogueResource]
@export var bad_ending: DialogueResource
@export var neutral_ending: DialogueResource
@export var good_ending: DialogueResource


func is_last_chapter(chapter_number: int):
	return chapter_number == chapters.size()
