class_name ShooterDecorator
extends ShooterInterface

var base_shooter: ShooterInterface


func _init(shooter: ShooterInterface):
	base_shooter = shooter


func get_bullet_scene() -> PackedScene:
	return base_shooter.get_bullet_scene()


func get_bullet_speed() -> float:
	return base_shooter.get_bullet_speed()


func get_shoot_delay() -> float:
	return base_shooter.get_shoot_delay()


func shoot(from_position: Vector3, direction: Vector3, team_color: Color, parent: Node) -> void:
	base_shooter.shoot(from_position, direction, team_color, parent)
