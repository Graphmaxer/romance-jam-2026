extends Node

var pseudo: String
var reputations: Dictionary[String, int]
var progression: String
var love_interest: String


func get_reputation(firstname: String) -> int:
	if reputations.has(firstname):
		return reputations[firstname]
	return 0
