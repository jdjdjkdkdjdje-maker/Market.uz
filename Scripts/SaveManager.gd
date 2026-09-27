class_name SaveManager
extends RefCounted

const FILE_PATH := "user://uz_football_save.json"

static func save_game(data: Dictionary) -> void:
	var file := FileAccess.open(FILE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))

static func load_game() -> Dictionary:
	if not FileAccess.file_exists(FILE_PATH):
		return {}
	var file := FileAccess.open(FILE_PATH, FileAccess.READ)
	var parsed = JSON.parse_string(file.get_as_text())
	return parsed if parsed is Dictionary else {}
