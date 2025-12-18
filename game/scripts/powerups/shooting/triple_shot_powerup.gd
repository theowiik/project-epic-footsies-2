extends ShootingDecorator
class_name TripleShotPowerup

var spread_angle: float = 15.0


func shoot(from_position: Vector2, direction: Vector2, owner_node: Node2D) -> void:
	var angle = direction.angle()

	# Center bullet
	base_shooting.shoot(from_position, direction, owner_node)

	# Left bullet
	var left_dir = Vector2.from_angle(angle - deg_to_rad(spread_angle))
	base_shooting.shoot(from_position, left_dir, owner_node)

	# Right bullet
	var right_dir = Vector2.from_angle(angle + deg_to_rad(spread_angle))
	base_shooting.shoot(from_position, right_dir, owner_node)
