class_name ShooterDecorator
extends Shooter

var wrapped_shooter: Shooter


func _init(shooter: Shooter):
	wrapped_shooter = shooter


func get_shoot_delay() -> float:
	return wrapped_shooter.get_shoot_delay()


func shoot(context: ShootingContext) -> void:
	wrapped_shooter.shoot(context)
