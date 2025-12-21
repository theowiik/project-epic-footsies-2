extends ShootingCrystal
class_name TripleShotCrystal

var spread_angle: float = 15.0


func shoot(from_position: Vector3, direction: Vector3, owner_node: Node3D) -> void:
	# Center bullet
	base_shooting.shoot(from_position, direction, owner_node)

	# Left bullet (rotate around Z axis)
	var left_dir = direction.rotated(Vector3.FORWARD, deg_to_rad(spread_angle))
	base_shooting.shoot(from_position, left_dir, owner_node)

	# Right bullet (rotate around Z axis)
	var right_dir = direction.rotated(Vector3.FORWARD, -deg_to_rad(spread_angle))
	base_shooting.shoot(from_position, right_dir, owner_node)
