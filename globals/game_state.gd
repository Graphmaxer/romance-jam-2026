extends Node

var pseudo: String
var reputations: Dictionary[String, int]
var chapter_number: int
var love_interest: String


func get_reputation(firstname: String) -> int:
	if reputations.has(firstname):
		return reputations[firstname]
	return 0
