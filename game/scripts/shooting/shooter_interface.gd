class_name ShooterInterface
extends RefCounted


func shoot(_context: ShootingContext) -> void:
	push_error("ShooterInterface.shoot() not implemented")


func get_shoot_delay() -> float:
	push_error("ShooterInterface.get_shoot_delay() not implemented")
	return 0.0
