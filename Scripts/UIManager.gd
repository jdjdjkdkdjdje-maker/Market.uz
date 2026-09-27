class_name UIManager
extends CanvasLayer

var score_label: Label
var timer_label: Label
var status_label: Label
var menu_panel: Control

func label(text: String, size: int, color: Color) -> Label:
	var l := Label.new(); l.text = text; l.add_theme_font_size_override("font_size", size); l.add_theme_color_override("font_color", color); return l

func make_button(text: String, parent: Control, pos: Vector2, size: Vector2) -> Button:
	var b := Button.new(); b.text = text; b.position = pos; b.size = size; b.add_theme_font_size_override("font_size", 20); parent.add_child(b); return b

func setup_match(root: Control) -> void:
	score_label = label("TBG  0  -  0  RQJ", 28, Color.WHITE); score_label.position = Vector2(500, 24); root.add_child(score_label)
	timer_label = label("00:00", 22, Color("#16d9a0")); timer_label.position = Vector2(605, 65); root.add_child(timer_label)
	status_label = label("", 22, Color("#ffd166")); status_label.position = Vector2(520, 105); root.add_child(status_label)
	var hint := label("WASD — harakat    J — PAS    K — ZARBA    SPACE — SPRINT", 16, Color("#a9bad5")); hint.position = Vector2(32, 670); root.add_child(hint)
	var pass := make_button("PAS", root, Vector2(1060, 510), Vector2(150, 58)); pass.name = "Pas"
	var shot := make_button("ZARBA", root, Vector2(1060, 580), Vector2(150, 58)); shot.name = "Zarba"
	var sprint := make_button("SPRINT", root, Vector2(900, 580), Vector2(145, 58)); sprint.name = "Sprint"
	var joy := label("◉", 74, Color("#ffffff55")); joy.position = Vector2(94, 505); root.add_child(joy)
