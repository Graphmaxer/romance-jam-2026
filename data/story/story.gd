@tool
class_name Story
extends Resource

@export var characters: Array[Character]
@export var locations: Array[Location]


func get_character(firstname_or_alias: String) -> Character:
	for character: Character in characters:
		if character.firstname == firstname_or_alias or character.aliases.has(firstname_or_alias):
			return character
	return null


func get_location(alias: String) -> Location:
	for location: Location in locations:
		if location.aliases.has(alias):
			return location
	return null
