class_name Story
extends Resource

@export var characters: Array[Character]
@export var locations: Array[Location]


func get_character(firstname: String) -> Character:
	for character: Character in characters:
		if character.firstname == firstname:
			return character
	return null


func get_location(name: String) -> Location:
	for location: Location in locations:
		if location.aliases.has(name):
			return location
	return null
