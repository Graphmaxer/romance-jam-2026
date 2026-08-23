extends Node

var pseudo: String
var reputations: Dictionary[String, int]
var chapter_number: int
var love_interest: String
var save_datetime: String
var skip_prologue: bool = false
var bad_prologue_ending: bool = false


func reset_game() -> void:
	GameState.reputations.clear()
	GameState.chapter_number = 0
	GameState.love_interest = ""
	GameState.save_datetime = ""
	GameState.bad_prologue_ending = false


func get_reputation(firstname: String) -> int:
	if reputations.has(firstname):
		return reputations[firstname]
	return 0


func save_game() -> void:
	var save_file: FileAccess = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	var json_string: String = JSON.stringify(
		{
			"pseudo": pseudo,
			"reputations": reputations,
			"chapter_number": chapter_number,
			"love_interest": love_interest,
			"save_datetime": Time.get_datetime_string_from_system(),
		}
	)
	save_file.store_line(json_string)


func has_save() -> bool:
	return FileAccess.file_exists("user://savegame.save")


func get_save_preview() -> String:
	var json_dict: Dictionary = _parse_save()
	if json_dict and json_dict.has('chapter_number'):
		var saved_chapter_number: int = json_dict['chapter_number']
		if json_dict.has("love_interest"):
			var saved_love_interest: String = json_dict['love_interest']
			if saved_love_interest.length() > 0:
				if saved_chapter_number == 0:
					return "%s: Fin" % saved_love_interest
				return "%s: Chapitre %d" % [saved_love_interest, json_dict['chapter_number']]
		return "Prologue"
	return ''


func load_game() -> void:
	var json_dict: Dictionary = _parse_save()
	if json_dict:
		for key: String in json_dict.keys():
			if key in self:
				if typeof(self[key]) == TYPE_DICTIONARY:
					self[key].assign(json_dict[key])
				elif typeof(self[key]) == TYPE_INT and typeof(json_dict[key]) == TYPE_FLOAT:
					self[key] = int(json_dict[key])
				elif typeof(self[key]) == typeof(json_dict[key]):
					self[key] = json_dict[key]
				else:
					push_warning(
						"Invalid key %s type, expected %s, got %s"
						% [key, type_string(typeof(self[key])), type_string(typeof(json_dict[key]))]
					)
			else:
				push_warning("Unknown key %s in save" % key)


func _parse_save() -> Dictionary:
	if not has_save():
		return { }
	var save_file: FileAccess = FileAccess.open("user://savegame.save", FileAccess.READ)
	var json_string: String = save_file.get_as_text()
	var json: JSON = JSON.new()
	var parse_result: Error = json.parse(json_string)
	if not parse_result == OK:
		push_warning(
			"JSON Parse Error: %s in %s at line %d"
			% [json.get_error_message(), json_string, json.get_error_line()]
		)
		return { }
	var json_data: Variant = json.data
	if json_data and typeof(json_data) == TYPE_DICTIONARY:
		var json_dict: Dictionary = json_data
		return json_dict
	return { }
