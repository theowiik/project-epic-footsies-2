extends RefCounted
class_name ShooterInterface


func shoot(_from_position: Vector3, _direction: Vector3, _team_color: Color, _parent: Node) -> void:
	push_error("ShooterInterface.shoot() not implemented")


func get_bullet_scene() -> PackedScene:
	push_error("ShooterInterface.get_bullet_scene() not implemented")
	return null


func get_bullet_speed() -> float:
	push_error("ShooterInterface.get_bullet_speed() not implemented")
	return 0.0
