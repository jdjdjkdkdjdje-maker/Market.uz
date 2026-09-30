class_name BallController
extends RigidBody3D

func create_ball() -> BallController:
	var ball := BallController.new()
	ball.mass = 0.45
	ball.linear_damp = 0.35
	ball.angular_damp = 0.3
	var mesh := MeshInstance3D.new()
	var sphere := SphereMesh.new()
	sphere.radius = 0.16
	sphere.height = 0.32
	mesh.mesh = sphere
	var material := StandardMaterial3D.new()
	material.albedo_color = Color("#f3f6fb")
	mesh.material_override = material
	ball.add_child(mesh)
	var shape := CollisionShape3D.new()
	var sphere_shape := SphereShape3D.new()
	sphere_shape.radius = 0.16
	shape.shape = sphere_shape
	ball.add_child(shape)
	return ball

func kick(direction: Vector3, power: float, lift := 0.08) -> void:
	linear_velocity = direction.normalized() * power + Vector3.UP * lift
