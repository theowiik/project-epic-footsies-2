class_name ShooterDecorator
extends ShooterInterface

var base_shooter: ShooterInterface


func _init(shooter: ShooterInterface):
	base_shooter = shooter


func get_shoot_delay() -> float:
	return base_shooter.get_shoot_delay()


func shoot(context: ShootingContext) -> void:
	base_shooter.shoot(context)
