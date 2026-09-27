extends Node3D

# UZ FOOTBALL playable prototype. Procedural geometry keeps the APK small and original.
var ui: UIManager
var match: MatchManager
var ball: BallController
var controlled: PlayerController
var ai_players: Array[PlayerController] = []
var home_score := 0
var away_score := 0
var match_running := false
var field_size := Vector2(36, 20)
var last_goal_time := -10.0

func _ready() -> void:
	_build_lighting()
	_show_menu()

func _build_lighting() -> void:
	var world := WorldEnvironment.new()
	var env := Environment.new(); env.background_mode = Environment.BG_COLOR; env.background_color = Color("#07152c"); env.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR; env.ambient_light_color = Color("#9bb7dd"); env.ambient_light_energy = 0.45; env.tonemap_mode = Environment.TONE_MAPPER_FILMIC
	world.environment = env; add_child(world)
	var light := DirectionalLight3D.new(); light.rotation_degrees = Vector3(-55, -25, 0); light.light_color = Color("#fff2d0"); light.light_energy = 1.2; light.shadow_enabled = true; add_child(light)

func _make_mesh(parent: Node, mesh: Mesh, material_color: Color, pos: Vector3) -> MeshInstance3D:
	var item := MeshInstance3D.new(); item.mesh = mesh; var mat := StandardMaterial3D.new(); mat.albedo_color = material_color; item.material_override = mat; item.position = pos; parent.add_child(item); return item

func _show_menu() -> void:
	_clear_world()
	var camera := Camera3D.new(); camera.position = Vector3(0, 8, 13); camera.look_at_from_position(camera.position, Vector3.ZERO); add_child(camera); camera.current = true
	ui = UIManager.new(); add_child(ui)
	var panel := ColorRect.new(); panel.color = Color("#07152cf2"); panel.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); ui.add_child(panel)
	var title := ui.label("UZ FOOTBALL", 58, Color("#16d9a0")); title.position = Vector2(88, 72); panel.add_child(title)
	var sub := ui.label("MAYDONDA O‘ZINGNI KO‘RSAT", 18, Color("#a9bad5")); sub.position = Vector2(94, 145); panel.add_child(sub)
	var buttons := ["O‘YNASH", "KARYERA", "TURNIR", "JAMOA", "TRANSFER", "MASHG‘ULOT", "SOZLAMALAR"]
	for i in buttons.size():
		var b := ui.make_button(buttons[i], panel, Vector2(90, 205 + i * 58), Vector2(300, 46)); b.pressed.connect(_menu_clicked.bind(buttons[i]))
	var card := ColorRect.new(); card.color = Color("#102747"); card.position = Vector2(550, 130); card.size = Vector2(570, 430); panel.add_child(card)
	var card_title := ui.label("MOBIL FUTBOL. YANGI AVLOD.", 30, Color.WHITE); card_title.position = Vector2(40, 36); card.add_child(card_title)
	var info := ui.label("Original 3D stadion\nTezkor o‘yin va sun’iy intellekt\nPas, zarba, pressing va gol\n\nBarcha boshqaruv o‘zbek tilida", 22, Color("#d7e4f7")); info.position = Vector2(40, 105); card.add_child(info)
	var footer := ui.label("1.0.0  •  ANDROID 64-BIT", 14, Color("#6884a9")); footer.position = Vector2(90, 650); panel.add_child(footer)

func _menu_clicked(option: String) -> void:
	if option == "O‘YNASH" or option == "KARYERA" or option == "TURNIR": _show_team_selection(option)
	else:
		if ui and ui.get_child_count() > 0: ui.get_child(0).queue_free()
		var notice := ui.label(option + " bo‘limi keyingi yangilanishda tayyorlanadi.\nPlayable matchni boshlash uchun O‘YNASH tugmasini bosing.", 25, Color.WHITE); notice.position = Vector2(160, 260)
		var back := ui.make_button("ORTGA", ui, Vector2(160, 390), Vector2(220, 55)); back.pressed.connect(_show_menu)

func _show_team_selection(mode: String) -> void:
	if ui: ui.queue_free()
	ui = UIManager.new(); add_child(ui)
	var bg := ColorRect.new(); bg.color = Color("#07152c"); bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); ui.add_child(bg)
	var title := ui.label("JAMOANI TANLANG", 42, Color("#16d9a0")); title.position = Vector2(90, 60); bg.add_child(title)
	var note := ui.label("Rejim: " + mode + "   •   Original jamoalar", 19, Color("#a9bad5")); note.position = Vector2(94, 120); bg.add_child(note)
	for i in TeamManager.TEAMS.size():
		var team: Dictionary = TeamManager.TEAMS[i]
		var b := ui.make_button(team.name, bg, Vector2(100 + (i % 2) * 410, 200 + (i / 2) * 100), Vector2(350, 68)); b.modulate = team.color; b.pressed.connect(_start_match.bind(i))
	var back := ui.make_button("ORTGA", bg, Vector2(100, 500), Vector2(200, 55)); back.pressed.connect(_show_menu)

func _start_match(team_id: int) -> void:
	if ui: ui.queue_free()
	_clear_world()
	_build_stadium()
	var camera := Camera3D.new(); camera.position = Vector3(0, 25, 25); camera.look_at(Vector3.ZERO); add_child(camera); camera.current = true
	ui = UIManager.new(); add_child(ui); var root := Control.new(); root.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); ui.add_child(root); ui.setup_match(root)
	match = MatchManager.new(); add_child(match); match.start_match(); match.score_changed.connect(_on_score); match.match_finished.connect(_finish_match)
	var team_color: Color = TeamManager.TEAMS[team_id].color
	controlled = _spawn_player("Jasur Karimov", 0, Vector3(-8, 0, 0), team_color, true)
	_spawn_player("Azizbek Rahmonov", 0, Vector3(-3, 0, -4), team_color)
	_spawn_player("Bekzod Aliyev", 0, Vector3(-3, 0, 4), team_color)
	var enemy_color := Color("#e85b69")
	var rival := _spawn_player("Raqib hujumchisi", 1, Vector3(7, 0, 0), enemy_color); ai_players.append(rival)
	_spawn_player("Raqib himoyachi", 1, Vector3(3, 0, -4), enemy_color)
	ball = BallController.create_ball(); add_child(ball); ball.position = Vector3(-6, 0.3, 0)
	var ai := FootballAI.new(); add_child(ai); ai.configure(rival, ball, "Normal")
	var keeper := _spawn_player("Darvozabon", 1, Vector3(17, 0, 0), enemy_color)
	var gk := GoalkeeperAI.new(); add_child(gk); gk.configure(keeper, ball)
	match_running = true

func _build_stadium() -> void:
	var ground := BoxMesh.new(); ground.size = Vector3(42, 0.2, 26); _make_mesh(self, ground, Color("#145c47"), Vector3(0, -0.15, 0))
	var pitch := BoxMesh.new(); pitch.size = Vector3(36, 0.12, 20); _make_mesh(self, pitch, Color("#238b59"), Vector3(0, 0, 0))
	for z in [-10.2, 10.2]:
		var line := BoxMesh.new(); line.size = Vector3(36, 0.025, 0.08); _make_mesh(self, line, Color.WHITE, Vector3(0, 0.08, z))
	for x in [-18.2, 18.2]:
		var line2 := BoxMesh.new(); line2.size = Vector3(0.08, 0.025, 20); _make_mesh(self, line2, Color.WHITE, Vector3(x, 0.08, 0))
	var center := CylinderMesh.new(); center.top_radius = 3; center.bottom_radius = 3; center.height = 0.025; _make_mesh(self, center, Color("#6bb77d"), Vector3(0, 0.08, 0))
	for side in [-1, 1]:
		var stand := BoxMesh.new(); stand.size = Vector3(38, 4, 3); _make_mesh(self, stand, Color("#263b63"), Vector3(0, 2, side * 13))
		for i in 18:
			var fan := BoxMesh.new(); fan.size = Vector3(0.45, 0.45, 0.18); _make_mesh(self, fan, Color("#f7b955" if i % 3 == 0 else "#e85b69"), Vector3(-17 + i * 2, 4.3, side * 12.4))
	for x in [-19, 19]:
		var goal := BoxMesh.new(); goal.size = Vector3(0.3, 2.8, 7); _make_mesh(self, goal, Color.WHITE, Vector3(x, 1.4, 0))

func _spawn_player(label: String, team: int, pos: Vector3, color: Color, user := false) -> PlayerController:
	var p := PlayerController.new(); p.position = pos; p.setup(label, team, color, user); add_child(p); return p

func _physics_process(delta: float) -> void:
	if not match_running or not controlled: return
	var input := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	controlled.move_user(input, delta, Input.is_action_pressed("sprint"))
	if Input.is_action_just_pressed("pass_ball") or Input.is_action_just_pressed("shoot_ball"): _kick(Input.is_action_just_pressed("shoot_ball"))
	if ball and (ball.position.x > 18.5 or ball.position.x < -18.5):
		var is_home := ball.position.x > 18.5
		match.goal(not is_home); ball.position = Vector3(0, 0.3, 0); ball.linear_velocity = Vector3.ZERO; last_goal_time = match.match_seconds
	if ui and ui.timer_label:
		ui.timer_label.text = "%02d:%02d" % [int(match.match_seconds) / 60, int(match.match_seconds) % 60]
	if ui and match.match_seconds - last_goal_time < 2.2: ui.status_label.text = "GOL!  Hisob yangilandi"
	elif ui: ui.status_label.text = ""

func _kick(shoot: bool) -> void:
	if not ball or controlled.global_position.distance_to(ball.global_position) > 3.0: return
	var direction := Vector3(1, 0, 0)
	if shoot: ball.kick(direction, 11.0, 1.6)
	else: ball.kick(direction.rotated(Vector3.UP, 0.18), 7.0, 0.3)

func _on_score(home: int, away: int) -> void:
	home_score = home; away_score = away
	if ui and ui.score_label: ui.score_label.text = "TBG  %d  -  %d  RQJ" % [home, away]
	SaveManager.save_game({"jamoa":"Toshkent Burgutlari", "hisob":{"uy":home, "mehmon":away}, "vaqt":Time.get_datetime_string_from_system()})

func _finish_match(winner: String) -> void:
	match_running = false
	if ui:
		var end := ColorRect.new(); end.color = Color("#07152cf0"); end.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT); ui.add_child(end)
		var result := ui.label("O‘YIN YAKUNLANDI\n" + winner, 42, Color("#16d9a0")); result.position = Vector2(430, 235); end.add_child(result)
		var again := ui.make_button("QAYTA BOSHLASH", end, Vector2(430, 365), Vector2(270, 58)); again.pressed.connect(_show_menu)

func _clear_world() -> void:
	for child in get_children(): child.queue_free()
