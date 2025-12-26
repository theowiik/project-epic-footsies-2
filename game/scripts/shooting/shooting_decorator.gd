class_name ShooterDecorator
extends ShooterInterface

var wrapped_shooter: ShooterInterface


func _init(shooter: ShooterInterface):
	wrapped_shooter = shooter


func get_shoot_delay() -> float:
	return wrapped_shooter.get_shoot_delay()


func shoot(context: ShootingContext) -> void:
	wrapped_shooter.shoot(context)
