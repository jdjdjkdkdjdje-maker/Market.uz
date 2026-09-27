class_name SettingsManager
extends RefCounted

static var graphics := "MEDIUM"
static var fps := 60
static var camera_mode := "Televizion"
static var music := 70
static var effects := 80

static func save() -> void:
	SaveManager.save_game({"sozlamalar":{"grafika":graphics,"fps":fps,"kamera":camera_mode,"musiqa":music,"effektlar":effects}})
