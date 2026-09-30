class_name FootballAI
extends Node

var difficulty := "Normal"
var target: PlayerController
var ball: RigidBody3D
var goal_x := 17.0

func configure(player: PlayerController, ball_ref: RigidBody3D, level := "Normal") -> void:
	target = player
	ball = ball_ref
	difficulty = level

func _physics_process(delta: float) -> void:
	if not target or not ball: return
	var to_ball := ball.global_position - target.global_position
	to_ball.y = 0
	if to_ball.length() > 1.15:
		target.velocity = to_ball.normalized() * (3.0 + _level_bonus())
		target.move_and_slide()
	else:
		target.velocity = Vector3.ZERO
		if ball.global_position.x < 14.0:
			ball.linear_velocity = Vector3(5.0 + _level_bonus() * 2.0, 0.3, 0.0)

func _level_bonus() -> float:
	return {"Oson":0.0, "Normal":0.5, "Qiyin":1.0, "Professional":1.5, "Afsona":2.0}.get(difficulty, 0.5)
