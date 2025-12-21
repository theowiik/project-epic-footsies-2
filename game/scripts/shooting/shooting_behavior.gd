extends RefCounted
class_name ShootingBehavior


func get_bullet_speed() -> float:
	return 10.0


func shoot(from_position: Vector3, direction: Vector3, owner_node: Node3D) -> void:
	pass
