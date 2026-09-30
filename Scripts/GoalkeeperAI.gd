class_name GoalkeeperAI
extends Node

var keeper: PlayerController
var ball: RigidBody3D

func configure(player: PlayerController, ball_ref: RigidBody3D) -> void:
	keeper = player
	ball = ball_ref

func _physics_process(delta: float) -> void:
	if not keeper or not ball: return
	var desired := Vector3(17.0, 0.0, clamp(ball.global_position.z, -3.0, 3.0))
	keeper.global_position = keeper.global_position.lerp(desired, delta * 2.2)
