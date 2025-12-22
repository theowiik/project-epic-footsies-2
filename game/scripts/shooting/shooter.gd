extends RefCounted
class_name Shooter

## Abstract interface for shooters.
## Implementations should override these methods.


func shoot(_from_position: Vector3, _direction: Vector3, _owner_node: Node3D) -> void:
	push_error("Shooter.shoot() not implemented")


func get_bullet_scene() -> PackedScene:
	push_error("Shooter.get_bullet_scene() not implemented")
	return null


func get_bullet_speed() -> float:
	push_error("Shooter.get_bullet_speed() not implemented")
	return 0.0

