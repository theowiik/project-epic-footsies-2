extends ShooterInterface
class_name ShooterDecorator

var base_shooter: ShooterInterface


func _init(shooter: ShooterInterface):
	base_shooter = shooter


func get_bullet_scene() -> PackedScene:
	return base_shooter.get_bullet_scene()


func get_bullet_speed() -> float:
	return base_shooter.get_bullet_speed()


func shoot(from_position: Vector3, direction: Vector3, owner_node: Node3D) -> void:
	base_shooter.shoot(from_position, direction, owner_node)
