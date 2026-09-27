class_name MatchManager
extends Node

signal score_changed(home: int, away: int)
signal match_finished(winner: String)

var home_score := 0
var away_score := 0
var match_seconds := 0.0
var active := false
var duration := 180.0

func start_match() -> void:
	home_score = 0; away_score = 0; match_seconds = 0; active = true
	score_changed.emit(home_score, away_score)

func _process(delta: float) -> void:
	if not active: return
	match_seconds += delta
	if match_seconds >= duration:
		active = false
		var winner := "Durrang"
		if home_score != away_score: winner = "Toshkent Burgutlari" if home_score > away_score else "Raqib jamoa"
		match_finished.emit(winner)

func goal(home: bool) -> void:
	if not active: return
	if home: home_score += 1
	else: away_score += 1
	score_changed.emit(home_score, away_score)
