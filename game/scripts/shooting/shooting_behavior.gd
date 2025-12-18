extends RefCounted
class_name ShootingBehavior


func get_bullet_speed() -> float:
	return 500.0


func shoot(from_position: Vector2, direction: Vector2, owner_node: Node2D) -> void:
	pass
