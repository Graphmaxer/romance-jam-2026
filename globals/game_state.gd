extends Node

var pseudo: String
var reputations: Dictionary[String, int]
var chapter_number: int
var love_interest: String
var save_datetime: String


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


func get_save_datetime() -> String:
	var json_dict: Dictionary = _parse_save()
	print(json_dict)
	if json_dict and json_dict.has('save_datetime'):
		return json_dict['save_datetime']
	return ''


func load_game() -> void:
	var json_dict: Dictionary = _parse_save()
	if json_dict:
		for key: String in json_dict.keys():
			if key in self and typeof(self[key]) == typeof(json_dict[key]):
				print(json_dict[key])
				self[key] = json_dict[key]


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
