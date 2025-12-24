class_name TripleShotDecorator
extends ShooterDecorator

var spread_angle: float = 15.0


func shoot(from_position: Vector3, direction: Vector3, team_color: Color, parent: Node) -> void:
	base_shooter.shoot(from_position, direction, team_color, parent)

	var left_dir = direction.rotated(Vector3.FORWARD, deg_to_rad(spread_angle))
	base_shooter.shoot(from_position, left_dir, team_color, parent)

	var right_dir = direction.rotated(Vector3.FORWARD, -deg_to_rad(spread_angle))
	base_shooter.shoot(from_position, right_dir, team_color, parent)
