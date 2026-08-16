class_name Route
extends Resource

@export var character: Character
@export var chapters: Array[DialogueResource]
@export var ending: DialogueResource


func is_last_chapter(chapter_number: float) -> bool:
	return chapter_number == chapters.size()


func get_chapter(chapter_number: float) -> DialogueResource:
	return chapters[chapter_number - 1]
