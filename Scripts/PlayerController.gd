class_name PlayerController
extends CharacterBody3D

var speed := 5.0
var is_user := false
var team := 0
var player_name := "Futbolchi"
var stamina := 100.0
var body_color := Color.WHITE

func setup(label: String, team_id: int, color: Color, user_controlled := false) -> void:
	player_name = label
	team = team_id
	body_color = color
	is_user = user_controlled
	_build_body()

func _build_body() -> void:
	var material := StandardMaterial3D.new()
	material.albedo_color = body_color
	var body := MeshInstance3D.new()
	var capsule := CapsuleMesh.new()
	capsule.height = 1.25
	capsule.radius = 0.28
	body.mesh = capsule
	body.material_override = material
	body.position.y = 0.72
	add_child(body)
	var head := MeshInstance3D.new()
	var sphere := SphereMesh.new()
	sphere.radius = 0.22
	sphere.height = 0.44
	head.mesh = sphere
	head.position.y = 1.52
	var skin := StandardMaterial3D.new()
	skin.albedo_color = Color("#d59b72")
	head.material_override = skin
	add_child(head)

func move_user(input: Vector2, delta: float, sprinting: bool) -> void:
	var direction := Vector3(input.x, 0, input.y)
	if direction.length() > 1.0: direction = direction.normalized()
	var current_speed := speed * (1.55 if sprinting and stamina > 0 else 1.0)
	velocity = direction * current_speed
	move_and_slide()
	if sprinting and direction.length() > 0.1: stamina = max(0.0, stamina - delta * 16.0)
	else: stamina = min(100.0, stamina + delta * 5.0)
	if direction.length() > 0.1: look_at(global_position + direction, Vector3.UP)
