class_name TeamManager
extends RefCounted

const TEAMS := [
	{"name":"Toshkent Burgutlari", "color":Color("#16d9a0"), "short":"TBG"},
	{"name":"Samarqand Yulduzlari", "color":Color("#ffb84d"), "short":"SMY"},
	{"name":"Buxoro Qalqonlari", "color":Color("#65a9ff"), "short":"BXQ"},
	{"name":"Farg‘ona Lochinlari", "color":Color("#f56b8a"), "short":"FGL"}
]

const NAMES := ["Jasur Karimov", "Azizbek Rahmonov", "Bekzod Aliyev", "Diyor Sobirov", "Sardor Ergashev", "Kamron Yo‘ldoshev", "Umid Xasanov", "Shoxrux Nabiyev"]

static func make_players(team_index: int, color: Color) -> Array:
	var players: Array = []
	for i in 11:
		var role := "ST" if i == 10 else ("GK" if i == 0 else ("CB" if i < 4 else "CM"))
		players.append({"ism":NAMES[i % NAMES.size()], "pozitsiya":role, "reyting":60 + ((i * 7 + team_index * 3) % 29), "tezlik":65 + i % 25, "pas":60 + i % 30, "zarba":58 + (i * 3) % 35, "jamoa":TEAMS[team_index].name, "mamlakat":"O‘zbekiston"})
	return players
